defmodule Glayu.Tasks.New do

  @behaviour Glayu.Tasks.Task

  @doc """
  Run the new post task
  """
  def run(params) do
    type = params[:type]
    title = params[:title]
    path = get_path(title, type)
    if !File.exists?(path) do
      create_file(path, title, type)
      {:ok, %{status: :new, path: path, type: type}}
    else
      {:ok, %{status: :exists, path: path, type: type}}
    end
  end

  defp get_path(title, :post) do
    Glayu.Path.source_from_title(title, :draft)
  end

  defp get_path(title, :page) do
    Glayu.Path.source_from_title(title, :page)
  end

  defp create_file(path, title, :post) do
    if !File.exists?(path) do
      File.write(path, Glayu.Templates.Post.tpl(title))
    end
  end

  defp create_file(path, title, :page) do
    File.write(path, Glayu.Templates.Page.tpl(title))
  end

end