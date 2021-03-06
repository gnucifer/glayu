defmodule Glayu.Build.JobResume do

  def resume(job) do
    extract_results(Glayu.Build.JobsStore.get_values(job), 0, 0, [])
  end

  defp extract_results([%Glayu.Build.Record{status: :ok, total_files: total_files}|more_results], num_nodes, total_processed, errors) do
    extract_results(more_results, num_nodes + 1, total_processed + total_files, errors)
  end

  defp extract_results([%Glayu.Build.Record{status: :error, node: node, total_files: _, details: details}|more_results], num_nodes, total_processed, errors) do
    error = [:red, :bright, "\n#{inspect node}", :normal,  '\n', extract_error(details)]
    extract_results(more_results, num_nodes, total_processed, [error|errors])
  end

  defp extract_results([], num_nodes, total_processed, []) do
    {:ok, %{nodes: num_nodes, files: total_processed}}
  end

  defp extract_results([], num_nodes, total_processed, errors) do
   {:error, %{nodes: num_nodes, files: total_processed, errors: errors}}
  end

  defp extract_error({:shutdown, {_, error}}) do
    print_error(error)
  end

  defp extract_error({:shutdown, error}) do
    print_error(error)
  end

  defp extract_error(error) do
    print_error(error)
  end

  defp print_error(error) do
    if Exception.exception?(error) do
      Exception.message(error)
    else
      inspect error
    end
  end

end