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
export bell_plot

include("heatplots.jl")
export HeatPlot, heatplot, T2_ΓZ_plot

end # module QubitPlots
