module FlatHash
  Changeset = Struct.new :id, :time, :author, :modifications, :additions, :deletions, :description
end