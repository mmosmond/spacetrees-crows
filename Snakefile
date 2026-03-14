# input
trees = 'data/trees/{chrcode}/134inds.trees'
poplabels = 'data/poplabels.txt'
chrcodes = []
with open('data/chromosome_codes.txt','r') as f:
  for line in f:
    chrcodes.append(line.split()[0])

# --------------- fst -------------------------
windows = 'data/fstwindows_{species}-cnx_{chrcode}.npy'
fsts = 'data/fst_{species}-cnx_{chrcode}.npy'

rule fst:
  input:
    trees=trees,
    poplabels=poplabels
  output:
    windows=windows,
    fsts=fsts
  run:
    import numpy as np
    import tskit
    pops = []
    with open(input.poplabels,'r') as f:
      next(f)
      for line in f:
        pops.append(line.strip().split()[1])
    spix = [i for i,j in enumerate(pops) if j[:3]==wildcards.species]
    cornixix = [i for i,j in enumerate(pops) if j[2]=='x']
    ts = tskit.load(input.trees)
    window = list(ts.breakpoints())
    fst = ts.Fst([spix,cornixix], windows=window, mode='branch')
    np.save(output.windows, window)
    np.save(output.fsts, fst)

# -------------------- all --------------------------------------

rule all:
  input:
    expand(fsts, chrcode=chrcodes, species=['cor','ori']),
