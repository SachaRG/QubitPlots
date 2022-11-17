module QubitPlots

"---- Dependencies ----"

using Suppressor: @suppress_err
using Reexport
@suppress_err @reexport using Plots

using LaTeXStrings
using Statistics
using Measures
using DataFrames
using QuantumCircuits

using QuantumCircuits.SingleQubitOperators
using QuantumCircuits.TwoQubitOperators


default(linealpha = 1,
		legendfontsize = 10,
		titlefontsize = 12,
		xtickfontsize = 10,
		ytickfontsize = 10,
		xguidefontsize = 10,
		yguidefontsize = 10,
		size = (600,300),
		linewidth = 1.5,
		margin = 5mm)


"---- Definitions of functions and constants ----"

include("blochsphere.jl")
export blochwireframe, blochsphere


include("ensembleplots.jl")
export BlochEnsemble, blochensemble
export SeriesHistogram, serieshistogram

include("single_qubit_plots.jl")
export BlochTimeSeries, blochtimeseries
export qubit_plot
export blochprojections

include("two_qubit_plots.jl")
export bellplot, BellPlot

include("heatplots.jl")
export HeatPlot, heatplot, T2_ΓZ_plot

end # module QubitPlots
