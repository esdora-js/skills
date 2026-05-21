# Clarifying Questions Menu

Pick **at most 3** from this menu based on what's actually unclear. Don't ask things you already know from context.

Use the `AskUserQuestion` tool with one of these question/option sets.

## If target model / assistant is unclear and would change the answer

- **Question:** "Which assistant is this prompt for?"
- **Options:** Claude Code (CLI) / Claude.ai (web/desktop) / ChatGPT / Cursor or Windsurf / Other (say which)

## If deliverable is unclear

- **Question:** "What do you want the model to do?"
- **Options:** Answer a question about the code / Make a small edit / Build a new feature / Fix a bug / Refactor existing code

## If verification is unclear

- **Question:** "Can the model check its own work after each attempt?"
- **Options:** Yes — there are tests / Yes — visual (I'll diff screenshots) / Yes — a CLI / build / lint will tell us / No — I'll review manually

## If scope is unclear

- **Question:** "Roughly how big is this task?"
- **Options:** A single line or two / A few files / A whole module or feature / I don't know — that's what I want the model to figure out

## If planning preference is unclear (only ask if deliverable is small edit or larger)

- **Question:** "Want the model to propose a plan first, or just try it?"
- **Options:** Plan first, then approve / Just try it, I'll course-correct / Plan only — no code yet

## If codebase anchors are unclear

- **Question:** "Are there existing files or patterns the model should look at first?"
- **Options:** Yes — I'll @-mention them / Look at git history / Look at similar features — the model can find them / No, this is greenfield
