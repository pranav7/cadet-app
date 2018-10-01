import React, { Component } from 'react'
import Posts from '../../wrappers/Posts'

class PostDetails extends Component {
  constructor(props) {
    super(props)

    this.state = {
      post: null
    }
  }

  componentDidMount() {
    Posts.get(this.props.boardId, this.props.postId)
      .then((response) => {
        this.setState({
          post: response.post
        })
      })
  }

  render() {
    if(this.state.post != null) {
      return (
        <div className="post-header">
          <div className="header">{this.state.post.title}</div>
        </div>
      )
    } else {
      return(<div>Loading Post ...</div>)
    }
  }
}

export default PostDetails
