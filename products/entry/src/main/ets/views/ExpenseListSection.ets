import { FormInfo, ExpenseItem, ExpenseCategory } from '../models/ReimbursementModel';

@Component
export struct ExpenseListSection {
  @Consume('formInfo') formInfo: FormInfo;
  public onOpenCalculator: (itemId: string, currentAmount: string) => void = () => {};

  private categories: ExpenseCategory[] = [
    ExpenseCategory.TRANSPORTATION,
    ExpenseCategory.ACCOMMODATION,
    ExpenseCategory.CATERING,
    ExpenseCategory.OTHERS
  ];

  // Instant dynamic add
  private addItem(): void {
    try {
      this.formInfo.expenseList ??= [];
      const newItem = new ExpenseItem(ExpenseCategory.CATERING, '0', '');
      // Reassigning with a new array reference triggers an immediate UI update
      this.formInfo.expenseList = [...this.formInfo.expenseList, newItem];
    } catch (err) {
      console.error(`[ExpenseListSection] Failed to add item: ${JSON.stringify(err)}`);
    }
  }

  // Instant dynamic delete
  private deleteItem(index: number): void {
    try {
      if ((this.formInfo?.expenseList?.length ?? 0) <= 1) {
        this.getUIContext().showAlertDialog({
          title: 'Notice',
          message: 'At least one expense record is required.',
          confirm: {
            value: 'OK',
            action: () => {}
          }
        });
        return;
      }
      if (index >= 0 && index < this.formInfo.expenseList.length) {
        // Filter out the item and reassign a new array reference
        this.formInfo.expenseList = this.formInfo.expenseList.filter((_, idx: number) => idx !== index);
      }
    } catch (err) {
      console.error(`[ExpenseListSection] Delete error: ${JSON.stringify(err)}`);
    }
  }

  build() {
    Column() {
      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Text('2. Expense Details')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)

        Button('+ Add Item')
          .fontSize(12)
          .height(30)
          .backgroundColor('#007DFF')
          .onClick(() => this.addItem())
      }
      .width('100%')
      .margin({ bottom: 10 })

      List({ space: 10 }) {
        ForEach(this.formInfo?.expenseList ?? [], (item: ExpenseItem, index: number) => {
          ListItem() {
            Column({ space: 6 }) {
              // Row 1: Category Selection & Delete Button
              Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
                Select(this.categories.map((c: ExpenseCategory): SelectOption => ({ value: c })))
                  .selected(this.categories.indexOf(item?.category ?? ExpenseCategory.TRANSPORTATION))
                  .value(item?.category ?? ExpenseCategory.TRANSPORTATION)
                  .width('55%')
                  .onSelect((_, text?: string) => {
                    item.category = (text as ExpenseCategory) ?? ExpenseCategory.TRANSPORTATION;
                  })

                Button('Delete')
                  .fontSize(11)
                  .height(28)
                  .backgroundColor('#FF4D4F')
                  .onClick(() => this.deleteItem(index))
              }
              .width('100%')

              // Row 2: Amount input + Calculator Trigger Button
              Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
                Text('Amount ($):')
                  .fontSize(14)
                  .width('30%')

                TextInput({ text: item?.amountText ?? '0', placeholder: '0.00' })
                  .type(InputType.Number)
                  .width('48%')
                  .height(36)
                  .backgroundColor('#F1F3F5')
                  .onChange((val: string) => {
                    item.amountText = val ?? '0';
                  })

                Button('Calc')
                  .fontSize(12)
                  .width('18%')
                  .height(36)
                  .backgroundColor('#34C759')
                  .onClick(() => {
                    this.onOpenCalculator(item.id, item.amountText ?? '0');
                  })
              }
              .width('100%')

              // Row 3: Remarks
              Flex({ alignItems: ItemAlign.Center }) {
                Text('Remarks:')
                  .fontSize(14)
                  .width('30%')

                TextInput({ text: item?.remarks ?? '', placeholder: 'Details' })
                  .width('70%')
                  .height(36)
                  .backgroundColor('#F1F3F5')
                  .onChange((val: string) => {
                    item.remarks = val ?? '';
                  })
              }
              .width('100%')
            }
            .padding(10)
            .backgroundColor('#FAFAFA')
            .borderRadius(8)
            .border({ width: 0.5, color: '#E2E4E8' })
          }
        }, (item: ExpenseItem, index: number) => `${item?.id ?? index}_${index}`)
      }
      .width('100%')
    }
    .padding(12)
    .backgroundColor('#FFFFFF')
    .borderRadius(10)
    .margin({ top: 12 })
    .width('100%')
  }
}