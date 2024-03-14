import { LightningElement, api, track, wire } from "lwc";
import findRecords from "@salesforce/apex/ContactFormController.findRecords";

export default class SchoolTable extends LightningElement {
  columns = [
    { label: "Name", fieldName: "Name" },
    { label: "City", fieldName: "BillingCity" },
    { label: "State", fieldName: "BillingState" }
  ];
  @api institutions;
  @api objectApiName;
  @api coordinates;
  @track records;
  @track filteredRecords = [];

  get doesRecordExists() {
    return this.filteredRecords.length != 0;
  }

  @wire(findRecords, {
    objectName: "$objectApiName",
    institutions: "$institutions",
    coordinates: "$coordinates"
  })

  getSchoolData({ error, data }) {
    if (data) {
      this.records = data;
      this.filteredRecords = [...this.records];
    }
    if (error) {
      console.error(error);
    }
  }

  handleSchoolSearch(event) {
    const searchString = event.target.value;
    this.filteredRecords = this.records.filter((r) => {
      return r.Name?.toLowerCase().includes(searchString?.toLowerCase());
    });
  }
  getSelectedAccount(event) {
    const selectedRows = event.detail.selectedRows;
    const passEvent = new CustomEvent("recordselection", {
      detail: selectedRows[0]?.Id
    });
    this.dispatchEvent(passEvent);
  }
}
