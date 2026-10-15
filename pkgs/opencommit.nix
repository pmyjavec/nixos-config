# opencommit hard-codes `temperature: 0` AND `top_p: 0.1` in its OpenAI engine.
# Anthropic rejects the pair on Claude >= 4.5 ("temperature and top_p cannot
# both be specified"), which opencommit then misreports as "Model not found".
# Drop top_p so Claude works through the omp auth-gateway's OpenAI endpoint.
{ opencommit }:

opencommit.overrideAttrs (old: {
  postInstall = (old.postInstall or "") + ''
    cli=$out/lib/node_modules/opencommit/out/cli.cjs
    # The 10-space indent is unique to OpenAiEngine's params literal.
    grep -q '^          top_p: 0.1,$' "$cli"
    sed -i '/^          top_p: 0.1,$/d' "$cli"
  '';
})
