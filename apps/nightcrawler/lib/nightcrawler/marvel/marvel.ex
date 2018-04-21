defmodule Nightcrawler.Marvel do
  @moduledoc """
  The Marvel context.
  """

  import Ecto.Query, warn: false
  alias Nightcrawler.Repo

  alias Nightcrawler.Marvel.Series

  @doc """
  Returns the list of series.

  ## Examples

      iex> list_series()
      [%Series{}, ...]

  """
  def list_series do
    Repo.all(Series)
  end

  @doc """
  Gets a single series.

  Raises `Ecto.NoResultsError` if the Series does not exist.

  ## Examples

      iex> get_series!(123)
      %Series{}

      iex> get_series!(456)
      ** (Ecto.NoResultsError)

  """
  def get_series!(id), do: Repo.get!(Series, id)

  @doc """
  Creates a series.

  ## Examples

      iex> create_series(%{field: value})
      {:ok, %Series{}}

      iex> create_series(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_series(attrs \\ %{}) do
    %Series{}
    |> Series.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a series.

  ## Examples

      iex> update_series(series, %{field: new_value})
      {:ok, %Series{}}

      iex> update_series(series, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_series(%Series{} = series, attrs) do
    series
    |> Series.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Series.

  ## Examples

      iex> delete_series(series)
      {:ok, %Series{}}

      iex> delete_series(series)
      {:error, %Ecto.Changeset{}}

  """
  def delete_series(%Series{} = series) do
    Repo.delete(series)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking series changes.

  ## Examples

      iex> change_series(series)
      %Ecto.Changeset{source: %Series{}}

  """
  def change_series(%Series{} = series) do
    Series.changeset(series, %{})
  end

  alias Nightcrawler.Marvel.Comic

  @doc """
  Returns the list of comics.

  ## Examples

      iex> list_comics()
      [%Comic{}, ...]

  """
  def list_comics do
    Repo.all(Comic)
  end

  @doc """
  Gets a single comic.

  Raises `Ecto.NoResultsError` if the Comic does not exist.

  ## Examples

      iex> get_comic!(123)
      %Comic{}

      iex> get_comic!(456)
      ** (Ecto.NoResultsError)

  """
  def get_comic!(id), do: Repo.get!(Comic, id)

  @doc """
  Creates a comic.

  ## Examples

      iex> create_comic(%{field: value})
      {:ok, %Comic{}}

      iex> create_comic(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_comic(attrs \\ %{}) do
    %Comic{}
    |> Comic.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a comic.

  ## Examples

      iex> update_comic(comic, %{field: new_value})
      {:ok, %Comic{}}

      iex> update_comic(comic, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_comic(%Comic{} = comic, attrs) do
    comic
    |> Comic.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Comic.

  ## Examples

      iex> delete_comic(comic)
      {:ok, %Comic{}}

      iex> delete_comic(comic)
      {:error, %Ecto.Changeset{}}

  """
  def delete_comic(%Comic{} = comic) do
    Repo.delete(comic)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking comic changes.

  ## Examples

      iex> change_comic(comic)
      %Ecto.Changeset{source: %Comic{}}

  """
  def change_comic(%Comic{} = comic) do
    Comic.changeset(comic, %{})
  end
end
