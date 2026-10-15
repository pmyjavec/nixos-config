{ lib, python314Packages, fetchFromGitHub }:

python314Packages.buildPythonApplication rec {
  pname = "lgit";
  version = "5.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "can1357";
    repo = "llm-git";
    tag = "v${version}";
    hash = "sha256-G55A19VCXV0gZxgSzFu2FlUntJxMWuVMg9dwdONSlq0=";
  };

  build-system = [ python314Packages.hatchling ];

  dependencies = with python314Packages; [
    httpx
    jinja2
    blake3
  ];

  # Tests need network / LLM API access.
  doCheck = false;

  pythonImportsCheck = [ "lgit" ];

  meta = {
    description = "LLM-powered conventional commit message generator";
    homepage = "https://github.com/can1357/llm-git";
    license = lib.licenses.mit;
    mainProgram = "lgit";
  };
}
