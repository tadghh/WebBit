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

		let coolItem = [
			{ key: "text", value: this.textTarget.classList },
			{ key: "media", value: this.mediaTarget.classList },
			{ key: "url", value: this.urlTarget.classList },
		];

		coolItem.forEach(({ key, value }) => {
			if (interactedEvent === key) {
				value.remove("hidden");
			} else {
				value.add("hidden");
			}
		});
		this._showActiveTab(interactedEvent);
		// Below is a less spacious incomplete implementatin
		// if (interactedEvent == "text") {
		// 	this.textTarget.classList.remove("hidden");
		// 	this.urlTarget.classList.remove("hidden");
		// 	this.mediaTarget.classList.remove("hidden");
		// } else if (interactedEvent == "url") {
		// 	this.textTarget.classList.remove("hidden");
		// 	this.urlTarget.classList.remove("hidden");
		// 	this.mediaTarget.classList.remove("hidden");
		// }
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
