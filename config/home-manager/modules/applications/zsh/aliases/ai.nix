# Home Manager Zsh aliases module. Do not remove this header.
{
  ...
}:
let
  aliases = {
    oc = "opencode";
    ocr = "oc -m ${model} run";
    ocrC = "ocr commit and push the current state of the code-dont modify anything";
  };

  model = "ollama-cloud/kimi-k2.5";
in
{
  inherit aliases;
}
