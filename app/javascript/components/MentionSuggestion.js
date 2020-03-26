import React, { Component } from 'react'

const getSubstringIndex = (str, substr) => str.toLowerCase().indexOf(substr.toLowerCase());

class Suggestion extends Component {
  renderContent() {
    let { suggestion, query } = this.props
    return this.renderHighlightedDisplay(suggestion.display, suggestion.id, query);
  }

  renderHighlightedDisplay(display, id, query) {
    const { suggestion, focused } = this.props;
    let i = getSubstringIndex(display, query)

    if (i === -1) {
      return <span>{display}</span>
    }

    return (
      <div>
        <span style={{ marginRight: 8, fontSize: 15, fontWeight: 600, color: focused ? 'white' : 'black' }}>
          {suggestion.display}
        </span>
        <span style={{ fontSize: 'smaller', color: focused ? 'white' : '#777' }}>
          {id.substring(0, i)}
          <b>{id.substring(i, i + query.length)}</b>
          {id.substring(i + query.length)}
      </span>
      </div>
    )
  }

  render() {
    return (
      <li>
        {this.renderContent()}
      </li>
    )
  }
}

export default Suggestion;
