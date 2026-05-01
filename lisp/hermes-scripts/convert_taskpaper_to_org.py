#!/usr/bin/env python3
"""Convert OmniFocus TaskPaper export to org-mode format.

Usage:
    python3 convert_taskpaper_to_org.py /tmp/omnifocus.taskpaper -o todo.org --stats
    python3 convert_taskpaper_to_org.py /tmp/omnifocus.taskpaper --dry-run
"""

import argparse
import re
from dataclasses import dataclass, field
from datetime import datetime
from typing import Optional


# ── Data Model ──────────────────────────────────────────────

@dataclass
class TaskNode:
    title: str
    level: int  # tab indent: 0=root, 1=project, 2=task, ...
    tags: dict = field(default_factory=dict)
    notes: list = field(default_factory=list)
    children: list = field(default_factory=list)
    is_project: bool = False


# ── Tag Mapping ─────────────────────────────────────────────

TAG_MAP = {
    'When : 下班时间': '下班时间',
    'When : 公司午饭': '公司午饭',
    'When : 周末': '周末',
    'When : 碎片时间': '碎片时间',
    '影响 : 2个月': '影响_2个月',
    'learn AI': 'learn_AI',
}

KNOWN_TAGS_RE = re.compile(
    r'@(parallel|autodone|due|defer|planned|flagged|context|tags'
    r'|repeat-rule|repeat-method|repeat-schedule-type|repeat-anchor-date)\b'
)

TAG_VALUE_RE = re.compile(r'@([\w-]+)(?:\(([^)]*)\))?')


# ── Parser ──────────────────────────────────────────────────

class TaskPaperParser:
    def parse(self, filepath: str) -> TaskNode:
        with open(filepath, 'r', encoding='utf-8') as f:
            lines = f.readlines()

        root = TaskNode(title='root', level=-1)
        stack: list[tuple[int, TaskNode]] = [(-1, root)]
        current_task: Optional[TaskNode] = None

        for line in lines:
            raw = line.rstrip('\n')
            stripped = raw.lstrip('\t')
            indent = len(raw) - len(stripped)

            # Blank line: preserve inside notes
            if stripped.strip() == '':
                if current_task and current_task.notes:
                    current_task.notes.append('')
                continue

            # Task line: starts with "- "
            if stripped.startswith('- '):
                task_text = stripped[2:]
                title, tags = self._parse_task_line(task_text)

                node = TaskNode(title=title, level=indent, tags=tags)
                node.is_project = (indent == 1)

                # Pop stack to find parent
                while stack and stack[-1][0] >= indent:
                    stack.pop()
                parent = stack[-1][1]
                parent.children.append(node)
                stack.append((indent, node))
                current_task = node
            else:
                # Note line: attach to current task
                if current_task is not None:
                    current_task.notes.append(stripped.strip())

        self._clean_notes(root)
        return root

    def _parse_task_line(self, text: str) -> tuple[str, dict]:
        """Parse task title and @tags from a task line."""
        match = KNOWN_TAGS_RE.search(text)
        if match:
            title = text[:match.start()].rstrip()
            tag_str = text[match.start():]
        else:
            return text.rstrip(), {}

        tags = {}
        for m in TAG_VALUE_RE.finditer(tag_str):
            name, value = m.group(1), m.group(2)
            tags[name] = value if value is not None else True

        # Strip default OF metadata
        tags.pop('parallel', None)
        tags.pop('autodone', None)

        return title, tags

    def _clean_notes(self, node: TaskNode):
        """Remove trailing blank lines from notes, recursively."""
        while node.notes and node.notes[-1].strip() == '':
            node.notes.pop()
        for child in node.children:
            self._clean_notes(child)


# ── Renderer ────────────────────────────────────────────────

WEEKDAYS = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
FREQ_MAP = {'DAILY': 'd', 'WEEKLY': 'w', 'MONTHLY': 'm', 'YEARLY': 'y'}
SQL_KEYWORDS = {'ALTER', 'SELECT', 'CREATE', 'DROP', 'INSERT', 'UPDATE',
                'DELETE', 'SET', '--', 'GRANT', 'REVOKE', 'EXPLAIN', 'WITH'}


class OrgRenderer:

    def render(self, root: TaskNode) -> str:
        parts = [self._render_header()]
        # root -> omnifocus (level 0) -> projects (level 1)
        omnifocus_node = root.children[0]
        for project in omnifocus_node.children:
            parts.append(self._render_node(project, org_level=1))
        return '\n'.join(parts) + '\n'

    def _render_header(self) -> str:
        return '''\
# -*- mode: org; coding: utf-8 -*-
#+TITLE: Hermes Todo
#+STARTUP: overview indent
#+TODO: TODO NEXT WAITING DELEGATED SOMEDAY | DONE CANCELLED
#+PROPERTY: AI_ACTION_ALL query auto assist review delegate monitor capture synth
#+PROPERTY: ENERGY_ALL low medium high
#+PROPERTY: TIME_ALL 5min 15min 30min 1h 2h half-day
#+TAGS: FLAGGED(f) 下班时间(a) 公司午饭(l) 周末(w) 碎片时间(s) 影响_2个月(i) learn_AI(L)

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# AI-SCHEMA v1.0
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# FILE: org-mode TODO list. * = project, ** = task, max depth 4.
#
# TASK FORMAT:
# ** TODO Title                              :tag1:tag2:
# DEADLINE: <2026-05-01 Fri 18:00>
# :PROPERTIES:
# :DEFER:          [2026-04-01 Wed 00:00]
# :PLANNED_DATE:   [2026-04-21 Mon 09:00]
# :CONTEXT:        When : 下班时间
# :AI_ACTION:      query|auto|assist|review|delegate|monitor|capture|synth
# :ENERGY:         low|medium|high
# :TIME:           5min|15min|30min|1h|2h|half-day
# :OF_REPEAT_*:    preserved OmniFocus repeat metadata
# :END:
# Body text / notes. Long notes (>10 lines) in :NOTES: drawer.
#
# KEYWORDS: TODO NEXT WAITING DELEGATED SOMEDAY | DONE CANCELLED
#
# AI RULES:
# - Read/write directly, no emacsclient
# - Add: ** TODO under correct * Project (default: * Inbox)
# - Complete: TODO→DONE, add CLOSED: [timestamp]
# - Never delete (use CANCELLED), never modify DONE tasks
# - Respect :DEFER: dates, append to notes don't replace
# - Commit: "hermes: <verb> <scope>"
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
'''

    def _render_node(self, node: TaskNode, org_level: int) -> str:
        lines = []
        stars = '*' * org_level

        # Headline
        keyword = '' if node.is_project else 'TODO '
        org_tags = self._make_org_tags(node.tags)
        tag_str = '  :' + ':'.join(org_tags) + ':' if org_tags else ''
        lines.append(f'{stars} {keyword}{node.title}{tag_str}')

        # DEADLINE from @due
        if 'due' in node.tags:
            if 'repeat-rule' in node.tags:
                dl = self._render_repeat_deadline(
                    node.tags['due'], node.tags['repeat-rule'])
            else:
                dl = self._format_org_timestamp(node.tags['due'])
            lines.append(f'DEADLINE: {dl}')

        # Property drawer
        props = self._collect_properties(node.tags)
        if props:
            lines.append(':PROPERTIES:')
            for k, v in props.items():
                lines.append(f':{k}: {v}')
            lines.append(':END:')

        # Notes
        if node.notes:
            processed = self._detect_code_blocks(node.notes)
            if len(processed) > 10:
                lines.append(':NOTES:')
                lines.extend(processed)
                lines.append(':END:')
            else:
                lines.extend(processed)

        # Children
        for child in node.children:
            lines.append(self._render_node(child, org_level + 1))

        return '\n'.join(lines)

    def _make_org_tags(self, tags: dict) -> list[str]:
        result = []
        if tags.get('flagged'):
            result.append('FLAGGED')
        if 'tags' in tags:
            raw_tags = [t.strip() for t in tags['tags'].split(',')]
            for rt in raw_tags:
                mapped = TAG_MAP.get(rt, rt.replace(' ', '_').replace(':', '_'))
                if mapped not in result:
                    result.append(mapped)
        return result

    def _collect_properties(self, tags: dict) -> dict:
        props = {}
        if 'planned' in tags:
            props['PLANNED_DATE'] = self._format_inactive_timestamp(tags['planned'])
        if 'defer' in tags:
            props['DEFER'] = self._format_inactive_timestamp(tags['defer'])
        if 'context' in tags:
            props['CONTEXT'] = tags['context']
        for key in ['repeat-rule', 'repeat-method', 'repeat-schedule-type',
                     'repeat-anchor-date']:
            if key in tags:
                props['OF_' + key.upper().replace('-', '_')] = tags[key]
        return props

    def _format_org_timestamp(self, date_str: str) -> str:
        """'2026-05-01 18:00' -> '<2026-05-01 Fri 18:00>'"""
        dt = datetime.strptime(date_str, '%Y-%m-%d %H:%M')
        day = WEEKDAYS[dt.weekday()]
        return f'<{dt:%Y-%m-%d} {day} {dt:%H:%M}>'

    def _format_inactive_timestamp(self, date_str: str) -> str:
        """'2026-05-01 18:00' -> '[2026-05-01 Fri 18:00]'"""
        dt = datetime.strptime(date_str, '%Y-%m-%d %H:%M')
        day = WEEKDAYS[dt.weekday()]
        return f'[{dt:%Y-%m-%d} {day} {dt:%H:%M}]'

    def _render_repeat_deadline(self, due_str: str, repeat_rule: str) -> str:
        freq_m = re.search(r'FREQ=(\w+)', repeat_rule)
        int_m = re.search(r'INTERVAL=(\d+)', repeat_rule)
        freq = FREQ_MAP.get(freq_m.group(1), 'm') if freq_m else 'm'
        interval = int_m.group(1) if int_m else '1'
        ts = self._format_org_timestamp(due_str)
        # Insert repeater before closing >
        return ts[:-1] + f' .+{interval}{freq}>'

    def _detect_code_blocks(self, notes: list[str]) -> list[str]:
        """Wrap consecutive SQL-like lines in #+begin_src sql blocks."""
        result = []
        in_code = False
        for line in notes:
            words = line.strip().split()
            first = words[0].upper().rstrip(';') if words else ''
            is_sql = first in SQL_KEYWORDS
            if is_sql and not in_code:
                result.append('#+begin_src sql')
                in_code = True
            elif not is_sql and in_code and line.strip():
                result.append('#+end_src')
                in_code = False
            result.append(line)
        if in_code:
            result.append('#+end_src')
        return result


# ── Stats ───────────────────────────────────────────────────

def count_stats(node: TaskNode, depth=0) -> dict:
    stats = {
        'projects': 0,
        'tasks': 0,
        'with_due': 0,
        'with_defer': 0,
        'with_planned': 0,
        'flagged': 0,
        'with_notes': 0,
        'with_repeat': 0,
        'max_depth': depth,
    }

    if node.is_project:
        stats['projects'] += 1
    elif depth > 1:  # skip root and omnifocus node
        stats['tasks'] += 1

    if 'due' in node.tags:
        stats['with_due'] += 1
    if 'defer' in node.tags:
        stats['with_defer'] += 1
    if 'planned' in node.tags:
        stats['with_planned'] += 1
    if node.tags.get('flagged'):
        stats['flagged'] += 1
    if node.notes:
        stats['with_notes'] += 1
    if 'repeat-rule' in node.tags:
        stats['with_repeat'] += 1

    for child in node.children:
        child_stats = count_stats(child, depth + 1)
        for k, v in child_stats.items():
            if k == 'max_depth':
                stats[k] = max(stats[k], v)
            else:
                stats[k] += v

    return stats


# ── Main ────────────────────────────────────────────────────

def main():
    ap = argparse.ArgumentParser(
        description='Convert OmniFocus TaskPaper to org-mode')
    ap.add_argument('input', help='Path to .taskpaper file')
    ap.add_argument('-o', '--output', default='todo.org',
                    help='Output org file path (default: todo.org)')
    ap.add_argument('--dry-run', action='store_true',
                    help='Print to stdout instead of writing file')
    ap.add_argument('--stats', action='store_true',
                    help='Print conversion statistics')
    args = ap.parse_args()

    parser = TaskPaperParser()
    root = parser.parse(args.input)
    org_text = OrgRenderer().render(root)

    if args.dry_run:
        print(org_text)
    else:
        with open(args.output, 'w', encoding='utf-8') as f:
            f.write(org_text)
        print(f'Written to {args.output} ({len(org_text)} bytes)')

    if args.stats:
        stats = count_stats(root)
        print('\n--- Conversion Stats ---')
        for k, v in stats.items():
            print(f'  {k}: {v}')


if __name__ == '__main__':
    main()
