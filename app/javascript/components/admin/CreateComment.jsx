import React, { Component } from 'react'
import { Tab } from 'semantic-ui-react'

class CreateComment extends Component {
  render() {
    const panes = [
      { menuItem: 'Reply', render: () => <Tab.Pane>Reply</Tab.Pane> },
      { menuItem: 'Note', render: () => <Tab.Pane>Note</Tab.Pane> },
    ]

    return (
      <Tab panes={panes} />
    )
  }
}

export default CreateComment