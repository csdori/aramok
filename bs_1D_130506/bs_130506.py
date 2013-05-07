import LFPy
import numpy as np
import matplotlib.pylab as pl

#location of the output files
outname='/media/BA0ED4600ED416EB/agy/kCSD/progik/bs_futtat/bs_1D_130506/'

#set cell to electrode distance
d=30
#number of electrodes
elecnumb=10
###################x
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
            if cell.zmid[i] < 100 and cell.zmid[i] > -100 and \
                    cell.xmid[i] < 100 and cell.xmid[i] > -100:
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
    
    ax.axis([-61, 61, -61, 61])
    
    ax.set_title('Location-dependent extracellular spike shapes')
    
    #plotting the soma trace    
    ax = fig.add_axes([0.75, 0.55, 0.2, 0.35])
    ax.plot(cell.tvec, cell.somav)
    ax.set_title('Somatic action-potential')
    ax.set_ylabel(r'$V_\mathrm{membrane}$ (mV)')
    
    #plotting the synaptic current
  #  ax = fig.add_axes([0.75, 0.1, 0.2, 0.35])
   # ax.plot(cell.tvec, cell.synapses[0].i)
    #ax.set_title('Synaptic current')
    #ax.set_ylabel(r'$i_\mathrm{synapse}$ (nA)')
    #ax.set_xlabel(r'time (ms)')





###############
cell_parameters = {         
        'morphology' : '/media/BA0ED4600ED416EB/agy/kCSD/progik/ballsctick/ballstick.hoc',     # Mainen&Sejnowski, Nature, 1996
	'Ra': 123,
        'tstartms' : 0.,                 # start time of simulation, recorders start at t=0
        'tstopms' : 70.,                   # stop simulation at 200 ms. 
	'passive' : True,
    	'v_init' : -65,             # initial crossmembrane potential
    	'e_pas' : -65,              # reversal potential passive mechs
	'nsegs_method' :  'fixed_length',
#	'fixed_length': 20, # method for setting number of segments,
	'max_nsegs_length':30,
#	'lambda_f' : 500,           # segments are isopotential at this frequency
    'custom_code'  : ['/media/BA0ED4600ED416EB/agy/kCSD/progik/ballsctick/active.hoc'], # will run this file
}

#Generate the grid in xz-plane over which we calculate local field potentials
x = pl.linspace(d, d, elecnumb)
z = pl.linspace(-50, 550, elecnumb)

y = pl.linspace(0, 0, x.size)

#define parameters for extracellular recording electrode, using optional method
electrodeParameters = {
    'sigma' : 0.5,              # extracellular conductivity
    'x' : x,        # x,y,z-coordinates of contact points
    'y' : y,
    'z' : z,
     'method' : 'som_as_point',  #treat soma segment as sphere source
     #'method' : 'pointsource'
}
   





pointprocess= {
        'idx' : 0,
        'record_current' : True,
        'pptype' : 'IClamp',
        'amp' : 0.5,
        'dur' : 30,
        'delay' : 15
    }



##create extracellular electrode object
electrode = LFPy.RecExtElectrode(**electrodeParameters)

simulationParameters = {
	'electrode' : electrode, 
	'rec_imem' : True,  # Record Membrane currents during simulation
	'rec_isyn' : True,  # Record synaptic currents
}



#Initialize cell instance, using the LFPy.Cell class
cell = LFPy.Cell(**cell_parameters)
#set the position of midpoint in soma to Origo (not needed, this is the default)
cell.set_pos(xpos = 0, ypos = 0, zpos = 0)

stimulus = LFPy.StimIntElectrode(cell, **pointprocess)
	

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
elec = np.hstack(
	(electrode.x, electrode.y, electrode.z) 
)

np.savetxt(outname + 'elcoord_x_y_z',elec)


np.savetxt(outname + 'seglength',cell.length)
np.savetxt(outname + 'time',cell.tvec)

elprop=np.hstack(
(d,electrode.sigma)
)
np.savetxt(outname + 'elprop',elprop)
# Plotting of simulation results:
plotstuff(cell, electrode)
pl.show()


