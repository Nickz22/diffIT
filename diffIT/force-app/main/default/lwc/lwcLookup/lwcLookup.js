import { LightningElement, track, wire, api } from "lwc";
import findRecords from "@salesforce/apex/ContactFormController.findRecords";
export default class LwcLookup extends LightningElement {
  @track recordsList;
  @track searchKey = "";
  @api selectedValue;
  @api selectedRecordId;
  @api objectApiName;
  @api iconName;
  @api disable;
  @api lookupLabel;
  @track message;
  @api institutions;
  @api coordinates;
  lookupDebounceTimeoutId;

  onLeave(event) {
    setTimeout(() => {
      this.searchKey = "";
      this.recordsList = null;
    }, 300);
  }

  @api
  clearSelection() {
    this.selectedRecordId = "";
    this.selectedValue = "";
    this.searchKey = "";
    this.recordsList = null;
  }

  onRecordSelection(event) {
    this.selectedRecordId = event.target.dataset.key;
    this.selectedValue = event.target.dataset.name;
    this.searchKey = "";
    this.onSeletedRecordUpdate();
  }

  handleKeyChange(event) {
    this.searchKey = event.target.value.trim();

    // Clear the existing timeout on each key press
    if (this.timeoutId) {
      clearTimeout(this.timeoutId);
    }

    // Set a new timeout
    this.timeoutId = setTimeout(() => {
      if (this.searchKey.length >= 3) {
        this.getLookupResult();
      }
    }, 500);
  }

  removeRecordOnLookup(event) {
    this.searchKey = "";
    this.selectedValue = null;
    this.selectedRecordId = null;
    this.recordsList = null;
    this.onSeletedRecordUpdate();
  }

  getLookupResult() {
    findRecords({
      searchKey: this.searchKey,
      objectName: this.objectApiName,
      institutions: this.institutions,
      coordinates: this.coordinates
    })
      .then((result) => {
        if (result.length === 0) {
          this.recordsList = [];
          this.message = "No Records Found";
        } else {
          this.recordsList = result;
          this.message = "";
        }
        this.error = undefined;
      })
      .catch((error) => {
        this.error = error;
        this.recordsList = undefined;
      });
  }

  onSeletedRecordUpdate() {
    const passEventr = new CustomEvent("recordselection", {
      detail: {
        selectedRecordId: this.selectedRecordId,
        selectedValue: this.selectedValue
      }
    });
    this.dispatchEvent(passEventr);
  }
}
