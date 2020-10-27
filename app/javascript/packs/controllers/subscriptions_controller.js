import { Controller } from "stimulus";

export default class extends Controller {
  connect() {
    this.setupPaddle();
    this.setupSubscriptionBtnListener();
  }

  reloadPage() {
    location.reload();
  }

  setupPaddle() {
    Paddle.Setup({ vendor: 21845 });
  }

  setupSubscriptionBtnListener() {
    const paddleProductId = this.element.getAttribute("data-paddle-product-id");

    $("#start-subscription-btn").click((event) => {
      Paddle.Checkout.open({
        product: paddleProductId,
        email: event.target.dataset.email,
        passthrough: event.target.dataset.passthrough,
        closeCallback: this.reloadPage,
      }, false);
    })
  }
}
