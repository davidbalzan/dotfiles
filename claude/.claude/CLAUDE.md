# User Preferences

## TypeScript & Code Quality
- Strong typing is important - sparse use of `any` where it simplifies is fine but do not overuse
- Prefer type inference when possible over explicit annotations
- Avoid lazy type shortcuts - take time to define proper types/interfaces
- Use `as const` assertions for literal types when appropriate

## Code Style
- Keep solutions simple and focused - avoid over-engineering
- Prefer editing existing files over creating new ones
- Don't add unnecessary comments or docstrings to unchanged code
- Use conventional commits: `feat:`, `fix:`, `refactor:`, `chore:`

## Communication
- Be direct and concise - avoid excessive praise or filler
- When uncertain, investigate first rather than guessing
- Show file paths with line numbers when referencing code (e.g., `src/file.ts:42`)
- Explain what you are building and the rationale in a concise manner

## Development Workflow
- Run builds/tests to verify changes compile before committing
- Stage specific files rather than `git add -A`
- Write descriptive commit messages that explain the "why"

@RTK.md

## Shared Tooling Repos

David maintains two reusable repos that apply across all his projects. Check for them before reaching for ad-hoc solutions.

### groundwork — `github:davidbalzan/groundwork`

Per-project scaffolding bolt-on. Installs skills, doc files, and helper scripts into the current repo.

```bash
npx github:davidbalzan/groundwork init          # full install
npx github:davidbalzan/groundwork init . --minimal   # 6 core skills only
```

**What it provides:**
- Skills: `/kickstart`, `/create-prd`, `/plan-phase`, `/start-session`, `/check-task`, `/next`, `/update-workstreams`, `/log-decision`, `/remember`, `/add-data-layer`, `/domain-model`
- Doc methodology: `STACK_MAP.md`, `WORKSTREAMS.md`, `BACKLOG.md`, per-phase task files
- Multi-agent seam: `BACKLOG.md` (inbound queue) + `WORKSTREAMS.md` (live execution state) — the coordinator reads both
- Works in Claude Code, Cursor, and VS Code

**When to use:** starting a new project, onboarding a project that lacks structured planning docs, or adding a missing skill to an existing groundwork project.

### agent-coordination — `github:davidbalzan/agent-coordination`

Global multi-agent coordination skills. Installs once to `~/.claude/skills/` and is available in all projects.

```bash
npx github:davidbalzan/agent-coordination install
```

**The four roles (invoke via `/skill-name`):**
| Skill | Role | Owns |
|---|---|---|
| `/coordinator` | Chief-of-staff — routes work, maintains live board, escalates to David | `LIVE_STATE_<project>.md`, `## Done` in `BACKLOG.md` |
| `/coord-worker --id= --lane= --rooms= --repo=` | Lane owner — implements a scoped slice of work in an isolated worktree | Its assigned worktree + PR |
| `/coord-curator` | David's planning intake — turns asks into queued backlog items, never executes code | `## Queue` in `BACKLOG.md` |
| `/coord-qa` | Review-and-merge gate — listens for `DONE:`, runs typecheck+build+tests, merges on pass | Integration branch gate |

**Never hand-edit `~/.claude/skills/` directly — re-run the install command to update.**

**When to use:** any project with parallel workstreams, multi-agent pipelines, or where David wants a coord-curator to decouple planning from execution.

### coord-mcp — the agentic bus

The live transport layer that connects all the roles above. Exposed as `mcp__agent-coord__*` MCP tools — available to every agent once the MCP server is connected.

**Chatrooms:** each project gets a room (`#<project>`) for lane work; `#general` is cross-project / David only. Agents join their project room on startup and do all lane work there. DMs between agents use `send_message to: "<agentId>"` — prefer DMs for bilateral contracts and coordinator escalations; broadcast to the room only for status that all lanes need.

**Standard fleet per project:**
| Agent ID | Skill | Purpose |
|---|---|---|
| `<proj>-coordinator` | `/coordinator` | Routes work, maintains `LIVE_STATE_<proj>.md`, gates promotions |
| `<proj>-backlog-curator` | `/coord-curator` | David's planning intake, owns `## Queue` in `BACKLOG.md` |
| `<proj>-quality-controller` | `/coord-qa` | Review-and-merge gate, runs typecheck+build+tests |
| `<proj>-worker-1/2/3` | `/coord-worker` | Lane owners, each in their own git worktree |

**Startup sequence (every agent):**
```
1. join { agentId, role, project }          # registers + attaches tmux transport
2. status { agentId }                        # verify transport=tmux-push
3. join_room #<project>                      # subscribe to project room
4. read_messages (inbox + project room)      # drain missed messages
5. post_status { … }                         # announce readiness once
```

**Message prefix protocol (hold on every message):**
- `FYI:` — informational, no action needed
- `AGENT_ACTION:` — agent is about to take an action
- `DAVID_DECISION:` — escalation, needs David (DM to coordinator only, never broadcast)
- `BLOCKER:` — lane is blocked
- `RISK:` — flagging a risk before proceeding
- `DONE:` — slice complete; **must cite a PR** (`owner/repo#N` or URL) + one-line result + next/blocked

**Agent-to-agent communication must be info-dense and token-efficient.** Strip all preamble, restatement, narration, and pleasantries. Every bus message should contain only what the recipient cannot already derive from context — goal, constraint, result, or blocker. One tight sentence beats three loose ones. No conversational ACKs ("acknowledged", "copy", "on it") — confirm via `post_status` or stay silent. David-facing messages (escalations, summaries) may use normal prose; agent↔agent traffic must not.

**The canonical playbook** lives in `davidbalzan/agent-coordination` — read the relevant section when a situation is ambiguous rather than guessing.

### How they fit together

groundwork sets up the project-level doc structure (`BACKLOG.md`, `WORKSTREAMS.md`) that the coord roles read and write. A typical new project:

1. `npx github:davidbalzan/groundwork init` — scaffolds docs + installs skills
2. Start coordinator (`/coordinator --project=<name>`) — picks up BACKLOG.md, creates LIVE_STATE
3. Start curator (`/coord-curator`) — joins bus as David's planning intake
4. Spawn coord-qa + 2–3 workers as workstreams open up
5. All agents join `#<project>` room on the coord-mcp bus; coordinator gates staging→main promotions in safe windows
