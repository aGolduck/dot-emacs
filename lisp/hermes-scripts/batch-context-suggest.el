;;; batch-context-suggest.el --- 基于标题关键词自动建议上下文标签
;; 用法: emacs --batch -l batch-context-suggest.el FILE [OUTPUT-FORMAT] [APPLY]
;; OUTPUT-FORMAT: "plain"(默认) | "json"
;; APPLY: 若为 "apply"，则直接应用建议的标签

(require 'org)
(load (expand-file-name "hermes-org-config.el" (file-name-directory load-file-name)))

(defvar hermes-file nil)
(defvar hermes-format "plain")
(defvar hermes-apply nil)

(setq hermes-file (pop command-line-args-left))
(when command-line-args-left
  (setq hermes-format (pop command-line-args-left)))
(when command-line-args-left
  (setq hermes-apply (string= (pop command-line-args-left) "apply")))

(unless hermes-file
  (error "用法: emacs --batch -l batch-context-suggest.el FILE [OUTPUT-FORMAT] [apply]"))

;; 标签规则表：((tag . (keyword1 keyword2 ...)) ...)
;; 优先级按列表顺序，先匹配的先应用
(defvar hermes/context-rules
  '(("@office" . ("公司" "办公" "代码" "开发" "测试" "部署" "服务器" "项目" "技术" "spring" "mcp" "flowable" "pg" "ck" "devcloud" "macbook" "apple" "linux" "proxy" "himalaya" "hermes" "gateway" "git" "emacs" "org" "ai" "AI" "研究" "学习" "论文" "书" "笔记" "博客" "blog"))
    ("@errand" . ("医院" "药" "发票" "体检" "银行" "农行" "开箱" "提金" "购买" "买" "换" "送" "寄" "取" "约" "餐厅" "超市" "便利店" "快递" "邮局" "加油" "洗车" "保养" "维修" "修"))
    ("@home" . ("家里" "房子" "装修" "沙发" "冰箱" "电视" "窗" "门铃" "行车记录仪" "极米" "投影仪" "保洁" "整理" "收纳"))
    ("@family" . ("爸妈" "父母" "宝" "孩子" "娃" "家人" "老婆" "夫人" "亲威" "亲属" "礼物" "回赠" "育儿" "孕" "产" "托" "幼儿" "吃饭" "餐椅" "去疤膏" "指甲" "洗澡"))
    ("@phone" . ("电话" "打电话" "联系" "通知" "回电" "咨询" "客服" "销户" "财院" "等信息"))
    ("@pc" . ("电脑" "mac" "macbook" "mac mini" "windows" "安装" "重装" "卸载" "软件" "工具" "steam" "令牌" "数据迁移" "备份" "升级" "更新" "重启"))
    ("@web" . ("网页" "网站" "注册" "登录" "账号" "密码" "邮箱" "订阅" "下载" "上传" "云" "cos" "网盘"))
    ("@quick" . ("刷" "牙" "牙膏" "洗脸" "拔" "剪" "洗" "擦" "拿" "带" "换" "调" "试" "穿" "放" "撤" "打扫" "倒" "扔" "补" "加" "填"))
    ("@night" . ("晚上" "睡前" "睡觉" "夜" "睡" "睡前" "躺" "休息" "放松"))
    ("@weekend" . ("周末" "假期" "旅游" "旅行" "出游" "足" "浴" "游戏" "看" "电影" "追" "剧"))
    ("@lunch" . ("午饭" "午餐" "吃饭" "饭" "菜" "点餐" "外卖"))
    ))

(defun hermes/suggest-tags-for-heading (title)
  "根据 TITLE 匹配规则表，返回建议标签列表。"
  (let ((suggestions nil)
        (case-fold-search t))
    (dolist (rule hermes/context-rules)
      (let ((tag (car rule))
            (keywords (cdr rule)))
        (when (catch 'matched
                (dolist (kw keywords)
                  (when (string-match-p (regexp-quote kw) title)
                    (throw 'matched t)))
                nil)
          (push tag suggestions))))
    (reverse suggestions)))

(find-file hermes-file)

(condition-case err
    (let ((suggestions nil)
          (applied-count 0))
      (org-map-entries
       (lambda ()
         (let* ((heading (org-get-heading t t t t))
                (current-tags (org-get-tags))
                (suggested (hermes/suggest-tags-for-heading heading))
                (to-add nil))
           ;; 只建议当前没有的标签
           (dolist (tag suggested)
             (unless (member tag current-tags)
               (push tag to-add)))
           (setq to-add (reverse to-add))
           (when to-add
             (push (list :line (line-number-at-pos (point))
                         :heading heading
                         :suggested to-add
                         :current current-tags)
                   suggestions)
             ;; 如果开启 apply 模式，直接打标签
             (when hermes-apply
               (dolist (tag to-add)
                 (org-toggle-tag tag 'on))
               (setq applied-count (1+ applied-count))))))
       nil 'file)

      (when hermes-apply
        (save-buffer))

      (setq suggestions (reverse suggestions))

      (if (string= hermes-format "json")
          (progn
            (princ "[\n")
            (let ((first t))
              (dolist (s suggestions)
                (unless first (princ ",\n"))
                (setq first nil)
                (princ (format "  {\"line\":%d,\"heading\":\"%s\",\"suggested\":[\"%s\"],\"current\":[\"%s\"]}"
                               (plist-get s :line)
                               (plist-get s :heading)
                               (mapconcat #'identity (plist-get s :suggested) "\",\"")
                               (mapconcat #'identity (plist-get s :current) "\",\"")))))
            (princ "\n]\n"))

        ;; Plain text
        (message "总计任务: %d" (length suggestions))
        (when hermes-apply
          (message "已应用标签的任务: %d" applied-count))
        (message "============================")
        (dolist (s suggestions)
          (message "[L%d] %s" (plist-get s :line) (plist-get s :heading))
          (message "  当前: %s" (or (plist-get s :current) "无"))
          (message "  建议: %s" (mapconcat #'identity (plist-get s :suggested) " "))
          (message "")))

      (message "============================")
      (when hermes-apply
        (message "DONE: 已保存所有变更"))

      (kill-emacs 0))

  (error
   (message "ERROR: %s" (error-message-string err))
   (kill-emacs 1)))
