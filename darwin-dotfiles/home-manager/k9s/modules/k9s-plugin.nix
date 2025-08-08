{ pkgs }:
{
  modify-secret = {
    shortCut = "Ctrl-X";
    description = "Edit Decoded Secret";
    confirm = false;
    scopes = [ "secrets" ];
    command = "sh";
    background = false;
    args = [
      "-c"
      ''
        tmpfile=$(mktemp /tmp/decoded-secret.XXXXXX.json)
        kubectl get secret "$NAME" -n "$NAMESPACE" -o json |
          jq '.data |= with_entries(.value |= @base64d)' > "$tmpfile"
        ${pkgs.getEditor or "vi"} "$tmpfile"
          jq '.data |= with_entries(.value |= @base64)' "$tmpfile" | kubectl apply -f -
      ''
    ];
  };
}
