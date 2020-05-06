module Constants::EventTypes
  STATUS_CHANGED = 0
  COMMENT_CREATED = 1
  MERGED = 2

  CLASSES = {
    STATUS_CHANGED => StatusChangedEvent,
    COMMENT_CREATED => CommentCreatedEvent
  }.freeze
end
