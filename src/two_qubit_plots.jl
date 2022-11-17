
# for plotting reduced qubit evolution in a two-qubit system
function single_qubit_plots(sol::Solution)
	colors = colors1q

	# calculate expectation values --------------------------------------------
	q1_basis = [σx1, σy1, σz1]
	q2_basis = [σx2, σy2, σz2]

	exps1 = map(op -> expectations(sol, op), q1_basis)
	exps2 = map(op -> expectations(sol, op), q2_basis)

	p1s = 0.5 * (1 .+ exps1[1].^2 .+ exps1[2].^2 .+ exps1[3].^2)
	p2s = 0.5 * (1 .+ exps2[1].^2 .+ exps2[2].^2 .+ exps2[3].^2)

	# plot ----------------------------------------------------------------------
	l = @layout [bloch1{0.5h}; bloch2{0.5h}]

	p1 = plot(sol.t, p1s, color=colors[4], label=L"Tr(\rho_1^2)", linestyle=:dash, title="single-qubit states")

	for l in 1:3
		label = qlabels[l]
		color = colors[l]
		exp = exps1[l]
		plot!(sol.t, exp, color=color, label=label, legend=:outerright, ylims=[-1,1])
	end

	p2 = plot(sol.t, p2s, color=colors[4], label=L"Tr(\rho_2^2)", linestyle=:dash, title="")

	for l in 1:3
		label = qlabels[l]
		color = colors[l]
		exp = exps2[l]
		plot!(sol.t, exp, color=color, label=label, legend=:outerright, xlabel="t (μs)", ylims=[-1,1])
	end

	plot(p1, p2, layout = l, link=:y, size=(600,300), legendfontsize=8, titlefontsize=12, legend=:outerright)
end



mutable struct BellPlot end
const bellplot = BellPlot()
@recipe function f(::BellPlot, sol::Solution; colorscheme = :rainbow, plotpurity=false)

	basis = bell_basis
	exps = map(op -> expectations(sol, dm(op)), basis)
	if plotpurity
		push!(exps, purity.(sol.ρ))
	end

	# Plot time series --------------------------------------------------------

	title --> "Bell states"
	legend --> :outerright
	label --> hcat(bell_basis_labels..., "purity")
	xlabel --> "t (μs)"
	ylabel --> "Bell state populations"

	colors = palette(colorscheme)[1:length(exps)]
	linealpha --> 1

	legendfontsize --> 10
	titlefontsize --> 12
	xtickfontsize --> 10
	ytickfontsize --> 10
	xguidefontsize --> 10
	yguidefontsize --> 10
	size --> (600,300)
	linewidth --> 1.5
	margin --> 5mm

	ylims --> [0, 1]


	for (c, exp) in zip(colors, exps)
		color := c

		@series begin
			sol.t, exp
		end

	end
end

# function ensavg(ens)
#     ρf = last(ens[1].ρ)
#     ρs = typeof(ρf) <: Ket ?
#         	mean(map(sol -> dm.(sol.ρ), ens)) :
#          	mean(map(sol -> sol.ρ, ens))
#     return Solution(ens[1].t, ρs)
# end
#
# function plotensemble(ens, avgsol, path; 	alpha=0.1,
# 											Nt=100,
# 											highlight_traj=0,
# 											highlight_width=0.5,
# 											plot_fidelity=false,
# 											plot_avg=true,
# 											title="",
# 											legend=:none,
# 											kwargs...)
#     al = plot_avg ? 1 : 0
# 	p = bellplot(avgsol; title = title,
# 					label = :none,
#                     legend = legend,
#                     size=(500,350),
#                     legendfontsize = 12,
#                     xtickfontsize=12,
#                     ytickfontsize=12,
#                     xlabelfontsize=12,
#                     ylabelfontsize=12,
#                     linewidth=3,
# 					linealpha = al,
#                     plotpurity=true, kwargs...)
#
#     @showprogress for sol in ens[1:Nt]
#         bellplot!(sol; title = title,
# 						legend = legend,
#                         label = :none,
#                         size=(500,350),
#                         legendfontsize = 12,
#                         xtickfontsize=12,
#                         ytickfontsize=12,
#                         xlabelfontsize=12,
#                         ylabelfontsize=12,
#                         linealpha = alpha,
#                         plotpurity=true, kwargs...)
#     end
# 	if highlight_traj > 0
# 	    bellplot!(Solution(ens[highlight_traj], bell_basis);
# 						  # label = :none,
# 						  legend = legend,
# 	                      size=(500,350),
# 	                      legendfontsize = 12,
# 	                      xtickfontsize=12,
# 	                      ytickfontsize=12,
# 	                      xlabelfontsize=12,
# 	                      ylabelfontsize=12,
# 	                      linewidth = highlight_width,
# 	                      plotpurity=true,
# 	                      title=title, kwargs...)
# 	end
# 	if plot_fidelity
# 		plot!(avgsol.t, map(ρ -> fidelity(ρ, Ψp), avgsol.ρ);
# 						  label = :none,
# 						  color = :black,
# 						  linewidth = 3)
#   	end
#
#     savefig(p, joinpath(path, "ensemble.png"))
#     return p
# end
#
# function plotensemble(ens, path; kwargs...)
# 	avgsol = ensavg(ens)
# 	return plotensemble(ens, avgsol, path; kwargs...)
# end
