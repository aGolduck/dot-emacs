#!/usr/bin/env python3
"""全面检测 batch 脚本与 Emacs 行为一致性。
测试原理：创建隔离的测试 org 文件，执行各种 batch 操作，
验证输出是否符合 hermes-org-config.el 中定义的共享配置。"""

import json, os, re, shutil, subprocess, sys, tempfile

TODO_DIR = "/data/home/bingezhou/s/hermes-todo"
SCRIPTS_DIR = f"{TODO_DIR}/scripts"
TEST_ORG = None

def run(cmd, check=True):
    r = subprocess.run(cmd, shell=True, capture_output=True, text=True, cwd=TODO_DIR)
    if check and r.returncode not in (0, 2):  # 2 = stuck-scan found stuck projects
        print(f"FAIL: {cmd}\nstdout: {r.stdout}\nstderr: {r.stderr}\nrc: {r.returncode}")
        sys.exit(1)
    return r

def setup_test_file():
    global TEST_ORG
    fd, TEST_ORG = tempfile.mkstemp(suffix="-test.org", prefix="hermes-test-", dir=TODO_DIR)
    os.close(fd)
    content = """# -*- mode: org; coding: utf-8 -*-
#+TITLE: Test Todo
#+TODO: TODO NEXT WAITING DELEGATED SOMEDAY | DONE CANCELLED

* inbox

** TODO 测试任务-简单
:PROPERTIES:
:AI_ACTION: auto
:END:
简单测试任务

** TODO 测试任务-等待
:PROPERTIES:
:AI_ACTION: assist
:END:

** TODO 测试任务-归档
CLOSED: [2026-01-01 Wed 12:00]
:PROPERTIES:
:AI_ACTION: auto
:END:

** TODO 测试任务-重复
DEADLINE: <2026-04-28 Tue 18:00 .+2m>
:PROPERTIES:
:AI_ACTION: monitor
:OF_REPEAT_RULE: FREQ=MONTHLY;INTERVAL=2
:END:

** TODO 测试任务-标签
:PROPERTIES:
:AI_ACTION: query
:END:

** NEXT 测试任务-已NEXT
:PROPERTIES:
:AI_ACTION: auto
:END:

**测试任务-无TODO
:PROPERTIES:
:AI_ACTION: auto
:END:

** TODO 测试任务-父任务
:PROPERTIES:
:AI_ACTION: assist
:END:
*** TODO 测试子任务-1
:PROPERTIES:
:AI_ACTION: auto
:END:
*** TODO 测试子任务-2
:PROPERTIES:
:AI_ACTION: auto
:END:

** TODO 测试任务-卡住
:PROPERTIES:
:AI_ACTION: auto
:END:
*** TODO 卡住子任务-A
:PROPERTIES:
:AI_ACTION: auto
:END:
*** TODO 卡住子任务-B
:PROPERTIES:
:AI_ACTION: auto
:END:
"""
    with open(TEST_ORG, "w", encoding="utf-8") as f:
        f.write(content)
    return TEST_ORG

def cleanup():
    if TEST_ORG and os.path.exists(TEST_ORG):
        os.remove(TEST_ORG)
    arc = TEST_ORG + "_archive" if TEST_ORG else None
    if arc and os.path.exists(arc):
        os.remove(arc)

def read_file():
    with open(TEST_ORG, "r", encoding="utf-8") as f:
        return f.read()

def assert_contains(text, *patterns):
    for p in patterns:
        if p not in text:
            print(f"  FAIL: 缺少期待内容: {p!r}")
            return False
    return True

def assert_not_contains(text, *patterns):
    for p in patterns:
        if p in text:
            print(f"  FAIL: 不应该出现: {p!r}")
            return False
    return True

results = []

def test(name, fn):
    print(f"\n── {name} ──")
    try:
        ok = fn()
        results.append((name, ok))
        if ok:
            print(f"  PASS")
        else:
            print(f"  FAIL")
    except Exception as e:
        print(f"  ERROR: {e}")
        results.append((name, False))

# ───────────────────────────────────────────────────────────────
def t_todo_to_done():
    run(f'emacs --batch -l {SCRIPTS_DIR}/batch-todo-state.el {TEST_ORG} "测试任务-简单" DONE')
    text = read_file()
    return (assert_contains(text, "** DONE 测试任务-简单", "CLOSED:")
            and assert_not_contains(text, ":WAITING:"))

def t_todo_to_waiting():
    run(f'emacs --batch -l {SCRIPTS_DIR}/batch-todo-state.el {TEST_ORG} "测试任务-等待" WAITING')
    text = read_file()
    return assert_contains(text, "** WAITING 测试任务-等待", ":WAITING:")

def t_waiting_to_next():
    # 先等待，再 NEXT
    run(f'emacs --batch -l {SCRIPTS_DIR}/batch-todo-state.el {TEST_ORG} "测试任务-等待" NEXT')
    text = read_file()
    return (assert_contains(text, "** NEXT 测试任务-等待")
            and assert_not_contains(text, ":WAITING:", ":WAITING:"))

def t_next_to_done():
    run(f'emacs --batch -l {SCRIPTS_DIR}/batch-todo-state.el {TEST_ORG} "测试任务-已NEXT" DONE')
    text = read_file()
    return assert_contains(text, "** DONE 测试任务-已NEXT", "CLOSED:")

def t_done_to_todo():
    run(f'emacs --batch -l {SCRIPTS_DIR}/batch-todo-state.el {TEST_ORG} "测试任务-归档" TODO')
    text = read_file()
    # 重开后应该保留 CLOSED 行（org-mode 设计如此）
    return assert_contains(text, "** TODO 测试任务-归档", "CLOSED:")

def t_cancelled_cycle():
    # CANCELLED → TODO
    run(f'emacs --batch -l {SCRIPTS_DIR}/batch-todo-state.el {TEST_ORG} "测试任务-简单" CANCELLED')
    run(f'emacs --batch -l {SCRIPTS_DIR}/batch-todo-state.el {TEST_ORG} "测试任务-简单" TODO')
    text = read_file()
    return (assert_contains(text, "** TODO 测试任务-简单")
            and assert_not_contains(text, ":CANCELLED:"))

def t_delegated_tag():
    run(f'emacs --batch -l {SCRIPTS_DIR}/batch-todo-state.el {TEST_ORG} "测试任务-标签" DELEGATED')
    text = read_file()
    return assert_contains(text, "** DELEGATED 测试任务-标签", ":WAITING:")

def t_someday_unchanged():
    run(f'emacs --batch -l {SCRIPTS_DIR}/batch-todo-state.el {TEST_ORG} "测试任务-简单" SOMEDAY')
    text = read_file()
    return assert_contains(text, "** SOMEDAY 测试任务-简单")

def t_add_todo():
    run(f'emacs --batch -l {SCRIPTS_DIR}/batch-add-todo.el {TEST_ORG} "新增测试任务" TODO B 2026-05-01 2026-05-10 office:urgent "测试任务-父任务" \'{{"AI_ACTION":"auto","ENERGY":"medium"}}\' "这是正文"')
    text = read_file()
    return (assert_contains(text, "*** TODO [#B] 新增测试任务 :office:urgent:",
                                   "SCHEDULED: <2026-05-01", "DEADLINE: <2026-05-10",
                                   ":AI_ACTION:", ":ENERGY:", "这是正文")
            and assert_not_contains(text, "错误"))

def t_schedule():
    run(f'emacs --batch -l {SCRIPTS_DIR}/batch-schedule.el {TEST_ORG} "测试任务-简单" SCHEDULED 2026-06-01')
    text = read_file()
    return assert_contains(text, "SCHEDULED: <2026-06-01")

def t_schedule_remove():
    run(f'emacs --batch -l {SCRIPTS_DIR}/batch-schedule.el {TEST_ORG} "测试任务-简单" SCHEDULED REMOVE')
    text = read_file()
    return assert_not_contains(text, "SCHEDULED: <2026-06-01")

def t_property():
    run(f'emacs --batch -l {SCRIPTS_DIR}/batch-add-property.el {TEST_ORG} "测试任务-简单" TEST_PROP test_value')
    text = read_file()
    return assert_contains(text, ":TEST_PROP:", "test_value")

def t_property_delete():
    run(f'emacs --batch -l {SCRIPTS_DIR}/batch-add-property.el {TEST_ORG} "测试任务-简单" TEST_PROP')
    text = read_file()
    return assert_not_contains(text, ":TEST_PROP:")

def t_archive():
    run(f'emacs --batch -l {SCRIPTS_DIR}/batch-archive-done.el {TEST_ORG} 0')
    text = read_file()
    arc_file = TEST_ORG + "_archive"
    archived = os.path.exists(arc_file)
    return (assert_not_contains(text, "** DONE 测试任务-归档")
            and archived)

def t_stuck_scan():
    r = run(f'emacs --batch -l {SCRIPTS_DIR}/batch-stuck-scan.el {TEST_ORG}', check=False)
    text = r.stdout + r.stderr
    # 卡住的项目应该有：测试任务-父任务（有子任务但无 NEXT），测试任务-卡住
    return (assert_contains(text, "卡住", "测试任务-卡住")
            and r.returncode == 2)

def t_context_suggest():
    r = run(f'emacs --batch -l {SCRIPTS_DIR}/batch-context-suggest.el {TEST_ORG}', check=False)
    text = r.stdout + r.stderr
    return assert_contains(text, "总计任务") or assert_contains(text, "建议")

if __name__ == "__main__":
    setup_test_file()
    try:
        test("状态: TODO→DONE", t_todo_to_done)
        test("状态: TODO→WAITING", t_todo_to_waiting)
        test("状态: WAITING→NEXT", t_waiting_to_next)
        test("状态: NEXT→DONE", t_next_to_done)
        test("状态: DONE→TODO", t_done_to_todo)
        test("状态: CANCELLED→TODO 循环", t_cancelled_cycle)
        test("状态: TODO→DELEGATED", t_delegated_tag)
        test("状态: TODO→SOMEDAY", t_someday_unchanged)
        test("新增: 带元数据的子任务", t_add_todo)
        test("日程: 设置/删除 SCHEDULED", t_schedule)
        test("日程: 移除 SCHEDULED", t_schedule_remove)
        test("属性: 增加/删除", t_property)
        test("归档: 已完成任务", t_archive)
        test("卡住: 扫描检测", t_stuck_scan)
        test("标签建议: 自动运行", t_context_suggest)
    finally:
        cleanup()

    print("\n" + "=" * 50)
    passed = sum(1 for _, ok in results if ok)
    total = len(results)
    print(f"结果: {passed}/{total} 通过")
    for name, ok in results:
        mark = "✅" if ok else "❌"
        print(f"  {mark} {name}")
    if passed < total:
        sys.exit(1)
