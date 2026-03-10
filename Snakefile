# input
trees = 'data/trees/{chrcode}/134inds.trees'
poplabels = 'data/poplabels.txt'
chrcodes = []
with open('data/chromosome_codes.txt','r') as f:
  for line in f:
    chrcodes.append(line.split()[0])

# --------------- fst -------------------------
windows = 'data/fst_windows_{chrcode}.npy'
fsts = 'data/fst_{chrcode}.npy'

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
    coroneix = [i for i,j in enumerate(pops) if j[2]=='r']
    cornixix = [i for i,j in enumerate(pops) if j[2]=='x']
    ts = tskit.load(input.trees)
    window = list(ts.breakpoints())
    fst = ts.Fst([coroneix,cornixix], windows=window, mode='branch')
    np.save(output.windows, window)
    np.save(output.fsts, fst)

# --------------- tmrcas -------------------------
tmrca_windows = 'data/tmrca_windows_{chrcode}.npy'
tmrcas = 'data/tmrcas_{chrcode}.npy'

rule tmrcas:
  input:
    trees=trees,
    poplabels=poplabels
  output:
    windows=tmrca_windows,
    tmrcas=tmrcas
  run:
    import numpy as np
    import tskit
    pops = []
    with open(input.poplabels,'r') as f:
      next(f)
      for line in f:
        pops.append(line.strip().split()[1])
    coroneix = [i for i,j in enumerate(pops) if j[2]=='r']
    cornixix = [i for i,j in enumerate(pops) if j[2]=='x']
    ts = tskit.load(input.trees)
    window = list(ts.breakpoints())
    np.save(output.windows, window)
    tmrca = []
    for ix in [coroneix, cornixix]:
      sample_sets = [[i] for i in ix]
      indexes = [(i,j) for i in range(len(ix)) for j in range(i,len(ix))]
      tmrcas = ts.divergence(sample_sets, indexes, windows='trees', mode='branch')
      tmrcas[np.isnan(tmrcas)] = 0 #tmrcas with self are said to be nan, so convert to 0
      tmrca.append(np.max(tmrcas,axis=1))
      print('within sp tmrcas done')
    sample_sets = [[i] for i in [coroneix+cornixix]]
    indexes = [(i,j) for i in range(len(coroneix)) for j in range(len(coroneix),len(coroneix+cornixix))]
    tmrcas = ts.divergence(sample_sets, indexes, windows='trees', mode='branch')
    tmrcas[np.isnan(tmrcas)] = 0 #tmrcas with self are said to be nan, so convert to 0
    tmrca.append(np.min(tmrcas,axis=1))
    np.save(output.tmrcas, tmrca)

# 

rule all:
  input:
    expand(fsts, chrcode=chrcodes),
    expand(tmrcas, chrcode=['NC_046347.1'])
