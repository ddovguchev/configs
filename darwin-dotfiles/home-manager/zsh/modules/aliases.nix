{
  ls = "eza --icons --group-directories-first --git -lh";
  ll = "eza -l --icons --group-directories-first --git";
  la = "eza -a --icons --group-directories-first --git -lh";
  l = "ls";

  grep = "grep --color=auto";
  egrep = "egrep --color=auto";
  fgrep = "fgrep --color=auto";
  cp = "cp -i";
  mv = "mv -i";
  rm = "rm -i";
  v = "nvim";
  vi = "nvim";
  vim = "nvim";
  c = "clear";
  nf = "clear; neofetch";

  # k8s
  k = "kubectl";
  kg = "kubectl get";
  ks = "kubectl -n kube-system";
  ksg = "kubectl -n kube-system";
  kconfig = "kubectl config view -o json | jq -r '.clusters[].name as \$cluster | .users[].name as \$user | .contexts[] | select(.context.cluster == \$cluster and .context.user == \$user) | \"context: \" + .name + \",\\ncluster: \" + .context.cluster + \",\\nuser: \" + .context.user + \"\\n\"'";

  # terraform
  t = "terraform";
  ti = "terraform fmt; terraform init";
  tp = "terraform fmt; terraform plan";
  ta = "terraform fmt; terraform apply";
  taa = "terraform fmt; terraform apply -auto-approve";
  td = "terraform destroy";
  tda = "terraform destroy -auto-approve";
  tw = "terraform workspace";

  # git
  gpl = "git log --graph --abbrev-commit --decorate --all --date=format:\"%Y-%m-%d %I:%M %p\" --format=format:\"%C(bold blue)%h%C(reset) - %C(bold cyan)%ad%C(dim white) - %an%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n %C(white)%s%C(reset)\"";
  gps = "git status --short --branch";
  gpb = "git for-each-ref --sort=-committerdate --format \"%(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(committerdate:relative)%(color:reset) - %(color:blue)%(contents:subject)%(color:reset)\" refs/heads/";
  gpba = "git for-each-ref --sort=-committerdate --format \"%(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(committerdate:relative)%(color:reset) - %(color:blue)%(contents:subject)%(color:reset)\" refs/heads/ refs/remotes/";
  ginit = "git init && git commit -m \"root\" --allow-empty";
}
