# Memory-Bank: Project Planning System

## Purpose

The memory-bank is a persistent, AI-friendly documentation system that captures all critical project knowledge for TakeYourPills. It ensures continuity across coding sessions, provides clarity on decisions, and enables any AI assistant to immediately understand the project's state, architecture, and next steps.

## File Map

```
memory-bank/
├── README.md                           # This file - overview and usage rules
├── project-overview.md                 # High-level product context
├── product-requirements.md             # Detailed requirements and acceptance criteria
├── implementation-plan.md              # Phased build sequence and milestones
├── architecture-decisions.md           # Record of architectural choices (ADR)
├── design-system-notes.md              # UI/UX patterns and component inventory
├── tasks.md                            # Prioritized backlog with status tracking
├── open-questions.md                   # Unresolved questions with assumptions
├── risk-register.md                    # Risk tracking with mitigations
└── session-handoff.md                  # Current status snapshot for handoffs
```

## Reading Order for Future AI Sessions

When starting work on this project, AI assistants should read files in this order:

1. **session-handoff.md** - Start here. Contains the most recent status, immediate next actions, and a reusable prompt.
2. **project-overview.md** - Understand the product essence and scope.
3. **architecture-decisions.md** - Core technical decisions and structure.
4. **design-system-notes.md** - UI patterns and component library reference.
5. **tasks.md** - Current backlog and what to work on next.
6. **product-requirements.md** - Detailed feature specifications if needed.
7. **implementation-plan.md** - Phase context and long-term sequencing.
8. **open-questions.md** - Known uncertainties and assumptions to verify.
9. **risk-register.md** - Potential issues to watch for.

## Rules for Updating After Every Milestone/Session

**MANDATORY:** At the end of every coding session or when a milestone is reached, update these files in the following order:

1. **session-handoff.md** - Always update first. Document:
   - What was accomplished
   - Current state of the codebase
   - Which files were modified/created
   - Immediate next recommended action
   - Any new open questions or decisions made

2. **tasks.md** - Update task status column for completed work. Add new tasks discovered during implementation. Update "Next 3 tasks" section based on current state.

3. **architecture-decisions.md** - Add new decisions with status "confirmed" if architecture was finalized, or "proposed" if tentative. Record any rejected alternatives with reasoning.

4. **open-questions.md** - Mark resolved questions as "resolved" with solution. Add new questions that emerged during work. Review and update assumptions.

5. **risk-register.md** - Add new risks identified. Update likelihood/impact for existing risks if circumstances changed. Add mitigation steps for realized issues.

6. **implementation-plan.md** - Adjust phase completion status if milestones were reached. Update suggested boundaries if MVP scope changed.

**Commit Trigger:** When a major milestone is reached (MVP completion, phase completion, major feature delivery), suggest to the user that they commit changes with a descriptive message referencing the memory-bank updates.

## Version Control Note

These files should be committed to version control alongside code changes. They are THE source of truth for project direction. When in doubt about a technical or product decision, consult these files first. When making changes that affect project direction, update the relevant memory-bank files immediately.

## File Status Conventions

- **Status fields**: `todo` | `in_progress` | `completed` | `cancelled` | `blocked`
- **Decision status**: `proposed` | `confirmed` | `rejected` | `deferred`
- **Priority**: `critical` | `high` | `medium` | `low`
- **Likelihood**: `certain` | `likely` | `possible` | `unlikely` | `rare`
- **Impact**: `critical` | `high` | `medium` | `low`

---

**Last Updated:** 2026-04-29  
**Project:** TakeYourPills  
**Phase:** Pre-initiation / Planning  
**Maintainer:** AI Planning System
