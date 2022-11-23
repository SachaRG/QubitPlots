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

import Simulations.Protocols.TwoQubitFeedback: θCR, Δθ, mag

mutable struct CRPlot end
const crplot = CRPlot()
@recipe function f(::CRPlot, qsol::QSol; colorscheme = :rainbow, plotpurity=false)

	sys = qsol.sys
	fil = qsol.fil

	@unpack td, dt, Ωmax, Δt_co, Δt_cn = qsol.protocol
	Ωθ = mag(θCR, Ωmax, Δt_co)
	ΩΔθ = mag(Δθ, Ωmax, Δt_cn)

	# Defaults for all plots
	title --> "Bell states"
	legend --> :outerright
	label --> hcat(bell_basis_labels...) #, "purity")
	xlabel --> "t (μs)"
	ylabel --> "Bell state populations"
	linealpha --> 1
	margin := 1mm
	size --> (500, 600)

	layout :=  fil == nothing ? (@layout [a ; b ; c]) : (@layout [a ; b ; c ; d])

	# subplot 1: bell states
	basis = bell_basis
	exps = map(op -> expectations(sys, dm(op)), basis)
	if plotpurity
		push!(exps, purity.(sys.ρ))
	end
	colors = palette(colorscheme)[1:length(exps)]

	for (c, exp) in zip(colors, exps)
		color := c

		@series begin
			ylims := [0,1]
			subplot := 1
			sys.t, exp
		end
	end

	if fil != nothing

		basis = bell_basis
		exps = map(op -> expectations(fil, dm(op)), basis)
		if plotpurity
			push!(exps, purity.(fil.ρ))
		end

		for (c, exp) in zip(colors, exps)
			color := c

			@series begin
				ylims := [0, 1]
				subplot := 2
				fil.t, exp
			end
		end
	end


	# subplot 2, 3 calculations: drive strengths
	delay = Int64(round(td / dt)) + 1
	ts = fil.t[delay:end]
	mag_co_timeseries = Ωθ.(fil.ρ[delay:end]) ./ 2π
	mag_cn_timeseries = ΩΔθ.(fil.ρ[delay:end]) ./ 2π

	# subplot 2: co-rotating drive strength
	@series begin
		xlims := [fil.t[1], fil.t[end]]
		subplot := fil != nothing ? 3 : 2
		ylabel := "MHz"
		label := ""
		title := "co-rotating drive"
		color := palette(:tab10)[1]
		ts, mag_co_timeseries
	end

	# subplot 3: counter-rotating drive strength
	@series begin
		xlims := [fil.t[1], fil.t[end]]
		subplot := fil != nothing ? 4 : 3
		ylabel := "MHz"
		label := ""
		title := "counter-rotating drive"
		color := palette(:tab10)[2]
		ts, mag_cn_timeseries
	end
end
