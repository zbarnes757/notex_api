defmodule Notex.Factory do
  use ExMachina.Ecto, repo: Notex.Repo

  def user_factory do
    %Notex.Accounts.User{
      username: Faker.Name.first_name(),
      password: Faker.String.base64(),
      password_hash: nil
    }
  end
end
