module QubitPlots

"---- Export symbols ----"

export blochwireframe, blochsphere
export BlochEnsemble, blochensemble
export SeriesHistogram, serieshistogram
export BlochTimeSeries, blochtimeseries
export qubit_plot
export blochprojections
export bell_plot


"---- Dependencies ----"

using Suppressor: @suppress_err
using Reexport
@suppress_err @reexport using Plots
import Makie, GLMakie, CairoMakie

using LaTeXStrings
using Statistics
using Measures
using DataFrames
using QuantumCircuits

using QuantumCircuits.SingleQubitOperators
using QuantumCircuits.TwoQubitOperators


"---- Definitions of functions and constants ----"

include("blochsphere.jl")
include("ensembleplots.jl")
include("single_qubit_plots.jl")
include("two_qubit_plots.jl")
include("heatplots.jl")

end # module QubitPlots