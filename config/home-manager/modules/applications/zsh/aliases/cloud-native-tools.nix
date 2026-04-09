# Home Manager Zsh aliases module. Do not remove this header.
{ platform, ... }:
let
  # Cloud Infrastructure - Cross-platform aliases
  sharedAliases = {
    # AWS
    aws_account_describe = "aws organizations describe-account --account-id $(aws_account_id)";
    aws_account_id = "aws sts get-caller-identity --query Account --output text";
    aws_account_region = "aws configure get region";
    aws-central-poc = "export AWS_PROFILE=THE_PROFILE_NAME";

    # Azure
    az_login = "az login";
    az_account_list = "az account list --output table";
    az_account_set = "az account set --subscription";
    az_aks_get_creds = "az aks get-credentials --resource-group codigocode-nonprod-aks-rg --name codigocode-nonprod-aks";
    az_group_list_codigocode = "az group list --query \"[?contains(name, 'codigocode')]\" --output table";
    kubelogin_convert = "kubelogin convert-kubeconfig --provider azure";

    # Docker
    d = "docker";
    dkps = "docker ps";
    dkpsa = "docker ps -a";
    dkimg = "docker images";
    dkrmi = "docker rmi";
    dkrmid = "docker rmi -d";
    dkrun = "docker run -it";
    dkbuild = "docker build";
    dkexec = "docker exec -it";
    dklogs = "docker logs -f";
    dkstop = "docker stop";
    dkkill = "docker kill";
    dkclean = "docker system prune -f";
    dkvol = "docker volume";
    dknet = "docker network";

    # Kubernetes
    k = "kubectl";
    h = "helm";
    k9s = "k9s --headless";
    kn = "k ns";
    kr = "k krew";
    kx = "k ctx";
    kga = "k get all";
    kgp = "k get pods";
    kgs = "k get services";
    kgd = "k get deployments";
    kgn = "k get nodes";
    kge = "k get events --sort-by='.lastTimestamp'";
    kaf = "k apply -f";
    kdf = "k delete -f";
    kex = "k exec -it";
    klo = "k logs -f";
    kdesc = "k describe";
    ktop = "k top nodes && kc top pods";
  };

  # GNU/Linux only aliases
  linuxAliases =
    if platform.isLinux then
      {
        # Minikube
        m = "minikube";
        minikube = "minikube-linux-amd64";

        # Podman
        po = "podman";
        poi = "podman images";
        pos = "podman search";
        popsa = "podman ps -a";
        potui = "podman-tui";
      }
    else
      { };

  # macOS only aliases
  darwinAliases =
    if platform.isDarwin then
      {
        minikube = "minikube-darwin-arm64";
      }
    else
      { };

  aliases = sharedAliases // linuxAliases // darwinAliases;
in
{
  inherit aliases;
}
