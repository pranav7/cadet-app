import React, { Component } from 'react'
import Posts from '../../wrappers/Posts'
import UpvoteButton from '../UpvoteButton';

class PostDetails extends Component {
  constructor(props) {
    super(props)

    this.state = {
      post: null
    }

    this.getPost = this.getPost.bind(this)
  }

  componentDidMount() {
    this.getPost(this.props.match.params.boardId, this.props.match.params.postId)
  }

  componentWillReceiveProps(nextProps) {
    this.getPost(nextProps.match.params.boardId, nextProps.match.params.postId)
  }

  getPost(boardId, postId) {
    Posts.get(boardId, postId)
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
          <div className="header">
            <h1 className="post-title">{this.state.post.title}</h1>
            <div className="post-header-info">
              <strong className={`status ${this.state.post.status}`}>
                #{this.state.post.status}
              </strong>
            </div>
           </div>
           <div className="votes">
             <UpvoteButton
                voteCount={this.state.post.votes_count}
                upvoted={this.state.post.upvoted}
                boardId={this.props.boardId}
                postId={this.props.postId}
             />
           </div>
        </div>
      )
    } else {
      return(<div>Loading Post ...</div>)
    }
  }
}

export default PostDetails
