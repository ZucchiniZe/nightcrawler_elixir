defmodule NightcrawlerWeb.LayoutView do
  use NightcrawlerWeb, :view

  def show_flash(conn) do
    conn
    |> get_flash
    |> flash_msg
  end

  def flash_msg(%{"info" => msg}) do
    ~E"""
    <div class="columns is-mobile">
      <div class="column is-half is-offset-one-quarter">
        <div class="notification is-info">
          <%= msg %>
        </div>
      </div>
    </div>
    """
  end

  def flash_msg(%{"error" => msg}) do
    ~E"""
    <div class="columns is-mobile">
      <div class="column is-half is-offset-one-quarter">
        <div class="notification is-danger">
          <%= msg %>
        </div>
      </div>
    </div>
    """
  end

  def flash_msg(_) do
    nil
  end
end
