import { util } from '@kit.ArkTS';

export enum ExpenseCategory {
  TRANSPORTATION = 'Transportation',
  ACCOMMODATION = 'Accommodation',
  CATERING = 'Catering',
  OTHERS = 'Others'
}

@Observed
export class ExpenseItem {
  public id: string = util.generateRandomUUID(true);
  public category: ExpenseCategory = ExpenseCategory.TRANSPORTATION;
  public amountText: string = '0';
  public remarks: string = '';

  constructor(category?: ExpenseCategory, amountText?: string, remarks?: string) {
    this.category = category ?? ExpenseCategory.TRANSPORTATION;
    this.amountText = amountText ?? '0';
    this.remarks = remarks ?? '';
  }

  // Safe amount calculation with try/catch and Number.isNaN check
  public getNumericAmount(): number {
    try {
      if (!this.amountText || this.amountText.trim().length === 0) {
        return 0;
      }
      const val: number = parseFloat(this.amountText);
      if (Number.isNaN(val) || val < 0) {
        return 0;
      }
      return val;
    } catch (err) {
      console.error(`Error parsing amountText: ${JSON.stringify(err)}`);
      return 0;
    }
  }
}

@Observed
export class FormInfo {
  public travelerName: string = '';
  public department: string = 'Engineering';
  public purpose: string = '';
  public startDate: string = '';
  public endDate: string = '';
  public travelCity: string = '';
  public agreementAccepted: boolean = false;
  public expenseList: ExpenseItem[] = [];

  constructor() {
    this.startDate = this.formatDate(new Date());
    const tomorrow = new Date();
    tomorrow.setDate(tomorrow.getDate() + 1);
    this.endDate = this.formatDate(tomorrow);
    this.expenseList = [new ExpenseItem(ExpenseCategory.TRANSPORTATION, '0', 'Initial Flight/Train')];
  }

  private formatDate(date: Date): string {
    return `${date.getFullYear()}-${(date.getMonth() + 1).toString().padStart(2, '0')}-${date.getDate().toString().padStart(2, '0')}`;
  }
}