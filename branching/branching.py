import LFPy
import numpy as np
import matplotlib.pylab as pl
import sys
#import os

#itt a bemenetek 3 spike-ot valtottak ki
#location of the output files
outname='/media/BA0ED4600ED416EB/agy/kCSD/progik/bs_futtat/branching/'

#set cell to electrode distance
#f1 = open('celleldist.txt', 'r')
#dist = [line.strip() for line in f1]
#d = int(dist[0])
#f1.close()
#d = 10
#number of electrodes
#elecnumb=20
f2 = open('elnum.txt', 'r')
elnb = [line.strip() for line in f2]
elecnumb = int(elnb[0])
f2.close()
#morphology
f3 = open('morphology.txt', 'r')
morph = [line.strip() for line in f3]
morpho = morph[0]
f3.close()

#where are the electrode coordinates
fewhere = open('elwhere.txt', 'r')
ewhere = [line.strip() for line in fewhere]
elwhere = ewhere[0]
fewhere.close()

felec = open(elwhere, 'r')
elec = [line.strip() for line in felec]
felec.close()
elc=np.hstack((elec))
elcor=elc.reshape(3,elecnumb)

###################
#Plotting

#set some plotting parameters
pl.rcParams.update({'font.size' : 15,
    'figure.facecolor' : '1',
    'left': 0.1, 'wspace' : 0.5 ,'hspace' : 0.5})


################################################################################
# Function declarations
################################################################################

def plotstuff(cell, electrode):
    #creating array of points and corresponding diameters along structure
    for i in xrange(cell.xend.size):
        if i == 0:
            xcoords = pl.array([cell.xmid[i]])
            ycoords = pl.array([cell.ymid[i]])
            zcoords = pl.array([cell.zmid[i]])
            diams = pl.array([cell.diam[i]])    
        else:
            if cell.zmid[i] < 600 and cell.zmid[i] > -200 and \
                    cell.xmid[i] < 100 and cell.xmid[i] > -400:
                xcoords = pl.r_[xcoords, pl.linspace(cell.xstart[i],
                                            cell.xend[i], cell.length[i]*3)]   
                ycoords = pl.r_[ycoords, pl.linspace(cell.ystart[i],
                                            cell.yend[i], cell.length[i]*3)]   
                zcoords = pl.r_[zcoords, pl.linspace(cell.zstart[i],
                                            cell.zend[i], cell.length[i]*3)]   
                diams = pl.r_[diams, pl.linspace(cell.diam[i], cell.diam[i],
                                            cell.length[i]*3)]
    
    #sort along depth-axis
    argsort = pl.argsort(ycoords)
    
    #plotting
    fig = pl.figure(figsize=[15, 10])
    ax = fig.add_axes([0.1, 0.1, 0.533334, 0.8], frameon=False)
    ax.scatter(xcoords[argsort], zcoords[argsort], s=diams[argsort]**2*20,
               c=ycoords[argsort], edgecolors='none', cmap='gray')
    ax.plot(electrode.x, electrode.z, '.', marker='o', markersize=5, color='k')
    
    i = 0
    limLFP = abs(electrode.LFP).max()
    for LFP in electrode.LFP:
        tvec = cell.tvec*0.6 + electrode.x[i] + 2
        if abs(LFP).max() >= 1:
            factor = 2
            color='r'
        elif abs(LFP).max() < 0.25:
            factor = 50
            color='b'
        else:
            factor = 10
            color='g'
        trace = LFP*factor + electrode.z[i]
        ax.plot(tvec, trace, color=color, lw = 2)
        i += 1
    
    ax.plot([22, 28], [-60, -60], color='k', lw = 3)
    ax.text(22, -65, '10 ms')
    
    ax.plot([40, 50], [-60, -60], color='k', lw = 3)
    ax.text(42, -65, '10 $\mu$m')
    
    ax.plot([60, 60], [20, 30], color='r', lw=2)
    ax.text(62, 20, '5 mV')
    
    ax.plot([60, 60], [0, 10], color='g', lw=2)
    ax.text(62, 0, '1 mV')
    
    ax.plot([60, 60], [-20, -10], color='b', lw=2)
    ax.text(62, -20, '0.1 mV')
    
    
    
    ax.set_xticks([])
    ax.set_yticks([])
    
    ax.axis([-61, 150, -150, 400])
    
    ax.set_title('Location-dependent extracellular spike shapes')
    
    #plotting the soma trace    
    ax = fig.add_axes([0.75, 0.55, 0.2, 0.35])
    ax.plot(cell.tvec, cell.somav)
    ax.set_title('Somatic action-potential')
    ax.set_ylabel(r'$V_\mathrm{membrane}$ (mV)')
    
    #plotting the synaptic current
    ax = fig.add_axes([0.75, 0.1, 0.2, 0.35])
    ax.plot(cell.tvec, cell.synapses[0].i)
    ax.plot(cell.tvec, cell.synapses[1].i)
    ax.plot(cell.tvec, cell.synapses[2].i)
    ax.set_title('Synaptic current')
    ax.set_ylabel(r'$i_\mathrm{synapse}$ (nA)')
    ax.set_xlabel(r'time (ms)')





###############
cell_parameters = {         
   #     'morphology' : '/media/BA0ED4600ED416EB/agy/kCSD/progik/bs_futtat/bs_130509/ballstick.hoc',     # Mainen&Sejnowski, Nature, 1996
#	'morphology' : '/media/BA0ED4600ED416EB/agy/kCSD/progik/bs_futtat/branching/branching.hoc',     # Mainen&Sejnowski, Nature, 1996
#	'morphology' : '/media/BA0ED4600ED416EB/agy/kCSD/progik/bs_futtat/branching/morphology/03a_pyramidal9aFI.CNG2.swc' ,    
	'morphology' : morpho ,    
#	'morphology' : '/media/BA0ED4600ED416EB/agy/kCSD/progik/bs_futtat/branching/branching.swc',
	'Ra': 123,
        'tstartms' : 0.,                 # start time of simulation, recorders start at t=0
        'tstopms' : 70.,                   # stop simulation at 200 ms. 
	'passive' : True,
    	'v_init' : -65,             # initial crossmembrane potential
    	'e_pas' : -65,              # reversal potential passive mechs
	'nsegs_method' :  'fixed_length',
#	'fixed_length': 20, # method for setting number of segments,
	#'max_nsegs_length':5, #igy kapunk 52 szegmenst
	'max_nsegs_length':10, #igy kapunk 27 szegmenst
#	'max_nsegs_length':30, #igy kapunk 18 szegmenst
#	'nsegs_method' : 'lambda_f',
#	'lambda_f' : 1000,           # segments are isopotential at this frequency
    'custom_code'  : ['/media/BA0ED4600ED416EB/agy/kCSD/progik/bs_futtat/branching/active.hoc'], # will run this file
}

#Generate the grid in xz-plane over which we calculate local field potentials
#x = pl.linspace(d, d, elecnumb)
#y = pl.linspace(-400, 100, elecnumb)
#z = pl.linspace(-150, 400, elecnumb)
#z = pl.linspace(-10, 10, 2)
#Y, Z = pl.meshgrid(y, z)
#x = pl.linspace(d, d, elecnumb*2)
x=elcor[0,]
x= x.astype('Float64')
y=elcor[1,]
y= y.astype('Float64')
z=elcor[2,]
z= z.astype('Float64')

#	y = pl.zeros(X.size)

#define parameters for extracellular recording electrode, using optional method
electrodeParameters = {
    'sigma' : 0.5,              # extracellular conductivity
    'x' : x,        # x,y,z-coordinates of contact points
    'y' : y,
    'z' : z,
#     'method' : 'som_as_point',  #treat soma segment as sphere source
#     'method' : 'pointsource'
     'method' : 'linesource'
}
   





#pointprocess= {
#        'idx' : 40,
#        'record_current' : True,
#        'pptype' : 'IClamp',
#        'amp' : 0.05,
#        #'amp' : 0.2,
#        'dur' : 30,
#        'delay' : 15
#    }



##create extracellular electrode object
electrode = LFPy.RecExtElectrode(**electrodeParameters)

simulationParameters = {
	'electrode' : electrode, 
	'rec_imem' : True,  # Record Membrane currents during simulation
	'rec_isyn' : True,  # Record synaptic currents
}




#Initialize cell instance, using the LFPy.Cell class
cell = LFPy.Cell(**cell_parameters)

#rotating the cell
#rotation = {'x' : np.pi/2, 'y' : 0, 'z' : 0}
#cell.set_rotation(**rotation)

#set the position of midpoint in soma to Origo (not needed, this is the default)
cell.set_pos(xpos = LFPy.cell.neuron.h.x3d(0) , ypos = LFPy.cell.neuron.h.y3d(0) , zpos = LFPy.cell.neuron.h.z3d(0))
#cell.set_pos(xpos = xpontok[1], ypos = ypontok[1], zpos = zpontok[1])



#Synaptic inputs


	    # Define synapse parameters
synapse_parameters = {
      'idx' : cell.totnsegs*1/4,
      'e' : 0.,                   # reversal potential
      'syntype' : 'ExpSyn',       # synapse type
      #'tau' : 10.,                # syn. time constant
	'tau' : 2.,
#      'weight' : .001,            # syn. weight
      'weight' : .002,            # syn. weight 
      'record_current' : True,
}

synapse_parameters2 = {
      'idx' : cell.totnsegs*2/4,
      'e' : 0.,                   # reversal potential
      'syntype' : 'ExpSyn',       # synapse type
      #'tau' : 10.,                # syn. time constant
	'tau' : 2.,
#      'weight' : .001,            # syn. weight
      'weight' : .003,            # syn. weight 
      'record_current' : True,
}

synapse_parameters3 = {
      'idx' : cell.totnsegs*3/4,
      'e' : 0.,                   # reversal potential
      'syntype' : 'ExpSyn',       # synapse type
      #'tau' : 10.,                # syn. time constant
	'tau' : 2.,
#      'weight' : .001,            # syn. weight
      'weight' : .004,            # syn. weight 
      'record_current' : True,
}


# Create synapse and set time of synaptic input
synapse = LFPy.Synapse(cell, **synapse_parameters)
synapse2 = LFPy.Synapse(cell, **synapse_parameters2)
synapse3 = LFPy.Synapse(cell, **synapse_parameters3)
#insert_synapses(synapse_parameters_2, **insert_synapses_2)
synapse.set_spike_times(np.array([2.]))
synapse2.set_spike_times(np.array([15.,20., 40.]))
synapse3.set_spike_times(np.array([5.,25., 44.]))



#stimulus = LFPy.StimIntElectrode(cell, **pointprocess)
	

#perform NEURON simulation, results saved as attributes in the cell instance
cell.simulate(**simulationParameters)

np.savetxt(outname + 'membcurr',cell.imem)
np.savetxt(outname + 'myLFP', electrode.LFP)

np.savetxt(outname + 'somav.txt', cell.somav)

coords = np.hstack(
	(cell.xmid, cell.ymid, cell.zmid) 
)

np.savetxt(outname + 'coordsmid_x_y_z',coords)


#szegmensek elejei
coordsstart = np.hstack(
	(cell.xstart, cell.ystart, cell.zstart) 
)

np.savetxt(outname + 'coordsstart_x_y_z',coordsstart)

#szegmensek vegei
coordsend = np.hstack(
	(cell.xend, cell.yend, cell.zend) 
)

np.savetxt(outname + 'coordsend_x_y_z',coordsend)

#szegmensek atmeroje
segdiam = np.hstack(
	(cell.diam) 
)

np.savetxt(outname + 'segdiam_x_y_z',segdiam)

##########x
#elec = np.hstack(
#	(electrode.x, electrode.y, electrode.z) 
#)

#np.savetxt(outname + 'elcoord_x_y_z',elec)


np.savetxt(outname + 'seglength',cell.length)
np.savetxt(outname + 'time',cell.tvec)

elprop=np.hstack(
(electrode.sigma,electrode.sigma)
)
np.savetxt(outname + 'elprop',elprop)
# Plotting of simulation results:
plotstuff(cell, electrode)
#pl.show()
pl.savefig('lfpy_setup.pdf')

################################x

#LFPy.cell.neuron.h...
h = LFPy.cell.neuron.h
hossz=len(cell.allsecnames)
f4 = open(outname + '/segcoords/branchnum', 'w')
f4.write(str(hossz))
f4.close()
b=0
for x in cell.allseclist:
	b=b+1
	xc=list()
	yc=list()
	zc=list()
	for i in range(int(h.n3d())):
                #print h.x3d(i)
		xc.append(h.x3d(i))
		yc.append(h.y3d(i))
		zc.append(h.z3d(i))	
	np.savetxt(outname + '/segcoords/segcord'+str(b),np.hstack((xc,yc,zc)))

