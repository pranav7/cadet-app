class ContentSerializer
  include FastJsonapi::ObjectSerializer

  attributes :body, :parsed
end
