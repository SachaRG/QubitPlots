function T2_ΓZ_plot(df::DataFrame; logy=false)

	fids = df.sys_fids
	ΓZs = union(df.ΓZ);
	T2s = union(df.T2)

	fig, ax, hm = Makie.heatmap(ΓZs, T2s, reshape(fids, (length(ΓZs),length(T2s))), xlabel="ΓZ")
	ax.xlabel = "ΓZ (MHz)"
	ax.ylabel = "T2 (μs)"
	ax.title = "fidelities with target state"
	if logy
		ax.yscale = log10
		ax.yticks = [0, 1, 2, 3, 5, 10, 20, 30, 50, 100]
	end
	Makie.Colorbar(fig[:, end+1], hm)

	return fig
end

function T2_ΓZ_plot(dfs...; logy=false)

	df = vcat(dfs...)
	df_sorted = sort(df, [:T2, :ΓZ])
	T2_ΓZ_plot(df_sorted; logy=logy)
end

function heatplot(x, y, values; logx=false, logy=false)

    fig, ax, hm = Makie.heatmap(x, y, values, xlabel="values")
    ax.xlabel = "x"
    ax.ylabel = "y"
    ax.title = "values as a function of x and y"
    if logy
        ax.yscale = log10
    end
    if logx
        ax.xscale = log10
    end
    Makie.Colorbar(fig[:, end+1], hm)

    return fig
end
