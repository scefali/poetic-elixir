defmodule PoeticWeb.UploadController do
  use PoeticWeb, :controller

  alias Poetic.Documents
  alias Poetic.Documents.Upload

  def new(conn, _params) do
    render(conn, "new.html")
  end
  
  def show(conn, %{"id" => id}) do
    upload = Documents.get_upload!(id)
    local_path = Upload.local_path(upload.id, upload.filename)
    send_download conn, {:file, local_path}, filename: upload.filename
  end

  def create(conn, %{"upload" => %Plug.Upload{}=upload}) do

    case Documents.create_upload_from_plug_upload(upload) do

      {:ok, upload}->
        put_flash(conn, :info, "file uploaded correctly")
        redirect(conn, to: Routes.upload_path(conn, :index))

      {:error, reason}->
        put_flash(conn, :error, "error upload file: #{inspect(reason)}")
        render(conn, "new.html")
    end

  end

  def index(conn, _params) do
    uploads = Documents.list_uploads()
    render(conn, "index.html", uploads: uploads)
  end
end