{ pkgs, lib, config, inputs, ... }:

{
  # https://devenv.sh/basics/
  env.GREET = "devenv";

  # https://devenv.sh/packages/
  packages = [
    pkgs.git
    pkgs.yamllint
    # required for openbolt (psych
    # https://discourse.nixos.org/t/error-running-rails-new-with-default-nix-ruby-anyone-has-manager-using-ruby-on-rails-on-nixos/36546
    pkgs.libyaml
  ];

  # https://devenv.sh/languages/
  languages.ruby.enable = true;
  languages.ruby.bundler.enable = true;
  # ruby 3.3 might be  required for porper usage of puppet-lint
  # https://github.com/puppetlabs/puppet-lint/issues/225
  # https://github.com/puppetlabs/puppet-lint/pull/233
  languages.ruby.package = pkgs.ruby_3_3;

  # https://devenv.sh/processes/
  # processes.cargo-watch.exec = "cargo-watch";

  # https://devenv.sh/services/
  # services.postgres.enable = true;

  # https://devenv.sh/scripts/
  scripts.hello.exec = ''
    echo hello from $GREET
  '';

  enterShell = ''
  '';

  # https://devenv.sh/tasks/
  tasks = {
    "bundler:install" = {
      exec = ''bundler install'';
      execIfModified = [
        "Gemfile"
        "Gemfile.lock"
      ];
    };
    "bolt:setup" = {
      exec = ''bolt module install --force'';
      execIfModified = [
        "bolt-project.yaml"
      ];
    };
    "devenv:enterShell".after = [ "bundler:install" ];
  };

  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running tests"
    yamllint data
    puppet-lint example
    puppet parser validate example
  '';

  # https://devenv.sh/git-hooks/
  # git-hooks.hooks.shellcheck.enable = true;

  # See full reference at https://devenv.sh/reference/options/
}
