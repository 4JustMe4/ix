import os


def cli_tool(ctx):
    args = ctx['args']
    pkgs = os.path.dirname(ctx['binary'])
    where = os.path.join(pkgs, 'pkgs', 'die', 'scripts')
    script = os.path.join(where, args[0])
    env = os.environ.copy()
    env.pop('SSL_CERT_FILE')
    env['IX_PKGS_ROOT'] = pkgs
    env['IX_BINARY'] = ctx['binary']
    os.execvpe(script, [script] + args[1:], env)
