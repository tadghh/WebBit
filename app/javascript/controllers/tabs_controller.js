import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
	static targets = ["button", "text", "url", "media"];
	connect() {
		console.log("tabs controller");
		this.buttonTargets[0].classList.add("bg-indigo-50");
	}
	toggle(event) {
		event.preventDefault();
		let interactedEvent = event.target.dataset.tabId;

		let submissionStyle = [
			{ key: "text", value: this.textTarget.classList },
			{ key: "media", value: this.mediaTarget.classList },
			{ key: "url", value: this.urlTarget.classList },
		];

		submissionStyle.forEach(({ key, value }) => {
			if (interactedEvent === key) {
				value.remove("hidden");
			} else {
				value.add("hidden");
			}
		});
		this._showActiveTab(interactedEvent);
	}
	_showActiveTab(tabId) {
		this.buttonTargets.forEach((btn) => {
			if (tabId == btn.dataset.tabId) {
				btn.classList.add("bg-indigo-50");
			} else {
				btn.classList.remove("bg-indigo-50");
			}
		});
	}
}
