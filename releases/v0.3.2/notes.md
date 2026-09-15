## What’s New

- Embedr's agent is clearer and more persistent, with stronger PCB, schematic, datasheet, firmware, and mechanical-design guidance.
- Embedr's PCB agent now follows a complete design-to-manufacturing workflow, with exact component selection, two-layer-first board planning, mechanical constraints, manual placement, routing review, and fabrication readiness.
- Auto Place and Auto Layout now perform stronger checks before using credits, preserve intentional placement locks, explain provider constraints, and avoid repeating unchanged paid jobs.
- Mounting holes and other non-plated mechanical holes are carried into routing automation as keepouts.
- New PCB checks combine schematic validation, KiCad design-rule checks, and manufacturing checks while keeping warnings visible until reviewed.
- Added indexed datasheet knowledge and semantic search to support component onboarding and grounded design decisions across desktop and web projects.
- Added clearer manufacturing-provider discovery, live quote estimates, supplier-aware BOM exports, and fabrication artifact handling.
- Web research now supports deeper cited research, focused page extraction, and retained results that can be read without issuing another research request.
- New PCB, datasheet, and research actions use the same compact, readable tool-call presentation in the desktop and browser apps.

This release also improves error explanations, rollback safety, packaged runtime reliability, and parity between desktop and web PCB workflows.
