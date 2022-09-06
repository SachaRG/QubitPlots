# function T2_ΓZ_plot(df::DataFrame; logy=false)
#
# 	fids = df.sys_fids
# 	ΓZs = union(df.ΓZ);
# 	T2s = union(df.T2)
#
# 	fig, ax, hm = Makie.heatmap(ΓZs, T2s, reshape(fids, (length(ΓZs),length(T2s))), xlabel="ΓZ")
# 	ax.xlabel = "ΓZ (MHz)"
# 	ax.ylabel = "T2 (μs)"
# 	ax.title =
# 	if logy
# 		ax.yscale = log10
# 		ax.yticks = [0, 1, 2, 3, 5, 10, 20, 30, 50, 100]
# 	end
# 	Makie.Colorbar(fig[:, end+1], hm)
#
# 	return fig
# end
#
# function T2_ΓZ_plot(dfs...; logy=false)
#
# 	df = vcat(dfs...)
# 	df_sorted = sort(df, [:T2, :ΓZ])
# 	T2_ΓZ_plot(df_sorted; logy=logy)
# end


mutable struct HeatPlot end
const heatplot = HeatPlot()

@recipe function f(::HeatPlot, x, y, z)
	arr = permutedims(hcat(z...))
    @assert size(arr) == (length(y), length(x))

	seriestype := :heatmap
	rightmargin --> 5mm
	size --> (550,450)

	@series begin
		x, y, arr
	end
end


function T2_ΓZ_plot(df::DataFrame)
	ΓZs = union(df.ΓZ)
	T2s = union(df.T2)
	fids = reshape(df.sys_fids, (length(ΓZs),length(T2s)))
	return plot(heatplot, ΓZs, T2s, fids, xlabel = "ΓZ (MHz)", ylabel = "T2 (μs)", title="fidelities with target state")
end

function T2_ΓZ_plot(dfs...)
	df = vcat(dfs...)
	df_sorted = sort(df, [:T2, :ΓZ])
	T2_ΓZ_plot(df_sorted)
end
