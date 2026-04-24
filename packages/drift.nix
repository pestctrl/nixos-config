{
  pkgs,
  fetchFromGitHub
}:
pkgs.buildGoModule rec {
  pname = "drift";
  version = "dev";
  src = fetchFromGitHub {
    owner = "phlx0";
    repo = "drift";
    rev = "main";
    hash = "sha256-QfxT7fhYeu70ZJnbJ3/LaBPgBzHbjwhQ0bPIMeR46/o=";
  };

  vendorHash = "sha256-FsNa9qp2MnPk1onv/O13mFi+82yP7D4LdILZsNzHs+4=";

  # CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.commit=none"
    "-X main.date=unknown"
  ];

  meta = with pkgs.lib; {
    description = "Terminal screensaver and ambient visualiser";
    homepage = "https://github.com/phlx0/drift";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "drift";
  };
}
