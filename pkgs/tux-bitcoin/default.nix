{ lib
, cowsay
, writers
}:

writers.writeBashBin "tux-bitcoin" ''
  bitcoin-cli "$@" | exec ${cowsay}/bin/cowsay -f tux
'' // {
  meta = with lib; {
    description = "A tux-flavored bitcoin-cli";
    homepage = "https://github.com/fort-nix/example-extension-flake/";
    license = licenses.mit;
    maintainers = with maintainers; [ erikarvstedt ];
    platforms = platforms.unix;
  };
}
