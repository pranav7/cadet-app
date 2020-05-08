export const PostsFilterOptions = [
  {
    text: 'Latest Activity',
    value: 'latest_activity',
    type: "sort",
  },
  {
    text: 'Most Voted',
    value: 'most_voted',
    type: "sort",
  },
  {
    text: 'Most Recent',
    value: 'most_recent',
    type: "sort",
  },
  {
    text: '#open',
    value: 'open',
    type: "status"
  },
  {
    text: '#planned',
    value: 'planned',
    type: "status"
  },
  {
    text: '#developing',
    value: 'developing',
    type: "status"
  },
  {
    text: '#released',
    value: 'released',
    type: "status"
  },
  {
    text: '#closed',
    value: 'closed',
    type: "status"
  }
];


export const postStatuses = [ 'open', 'planned', 'developing', 'released', 'closed' ];

export const EventTypes = {
  STATUS_CHANGED_EVENT: 0,
  COMMENT_CREATED_EVENT: 1,
}