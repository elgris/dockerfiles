# Obsidian AI Assistant image.

Build:

```bash
podman build -t obsidian-ai-image .
```

Run:
```bash
podman run -it --name obsidian-ai-container \
  --net dev-network \
  -v ~/.config/obsidian-ai/agent/:/home/pi/.pi/agent/:Z,U \
  -v ~/Documents/Obsidian/:/workspace:ro \
  obsidian-ai-image
```
