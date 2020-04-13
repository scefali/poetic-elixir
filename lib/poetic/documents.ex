defmodule Poetic.Documents do
  import Ecto.Query, warn: false

  alias Poetic.Repo
  alias Poetic.Documents.Upload

  def list_uploads do
    Repo.all(Upload)
  end
  
  def get_upload!(id) do
    Upload
    |> Repo.get!(id)
  end

  def create_upload_from_plug_upload(%Plug.Upload{
    filename: filename,
    path: tmp_path,
    content_type: content_type
  }) do
		
    # upload creation logic
    hash = 
      File.stream!(tmp_path, [], 2048) 
      |> Upload.sha256()


    Repo.transaction fn ->
      with {:ok, %File.Stat{size: size}} <- File.stat(tmp_path),  
        {:ok, upload} <- 
          %Upload{} |> Upload.changeset(%{
            filename: filename, content_type: content_type,
            hash: hash, size: size }) 
          |> Repo.insert(),
              
        :ok <- File.cp(
            tmp_path,
            Upload.local_path(upload.id, filename)
        )

      do
        
        {:ok, upload}

      else

        {:error, reason}=error -> error

      end

    end
  end

end