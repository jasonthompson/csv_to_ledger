Sequel.migration do
  change do
    create_table(:matchers) do
      primary_key :id
      String :vendor, :null=>false
      String :account, :null=>false
    end
  end
end
