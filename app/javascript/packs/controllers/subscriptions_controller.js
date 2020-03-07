import { Controller } from "stimulus"

export default class extends Controller {
  connect() {
    this.setupPaddle()
    this.setupSubscriptionBtnListener()
  }

  reloadPage() {
    location.reload()
  }

  setupPaddle() {
    Paddle.Setup({ vendor: 21845 });
  }

  setupSubscriptionBtnListener() {
    $("#start-subscription-btn").click((event) => {
      Paddle.Checkout.open({
        product: 586321,
        email: event.target.dataset.email,
        passthrough: event.target.dataset.passthrough,
        closeCallback: this.reloadPage
      }, false)
    })
  }
}
