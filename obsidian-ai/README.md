# Obsidian AI Assistant image.

Build:

```bash
podman build -t obsidian-ai-image .
```

Run:
```bash
podman run -it --name obsidian-ai-container \
  --net dev-network \
  -v ~/.config/obsidian-ai/agent/:/home/pi/.pi/agent/:U,Z \
  -v ~/Documents/Obsidian/:/workspace:ro,Z \
  obsidian-ai-image
```

Attach to a started one:
```bash
podman start -ai obsidian-ai-image
```