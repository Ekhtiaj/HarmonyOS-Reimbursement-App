@Component
export struct CalculatorPopup {
  @State private expression: string = '0';
  public onConfirmResult: (result: string) => void = () => {};
  public onClose: () => void = () => {};

  private keys: string[] = [
    'C', '←', '/', '*',
    '7', '8', '9', '-',
    '4', '5', '6', '+',
    '1', '2', '3', '=',
    '0', '.'
  ];

  public setInitialValue(val: string): void {
    this.expression = (!val || val === '0') ? '0' : val;
  }

  private handleKeyClick(key: string): void {
    try {
      if (key === 'C') {
        this.expression = '0';
        return;
      }
      if (key === '←') {
        this.expression = this.expression.length > 1 ? this.expression.substring(0, this.expression.length - 1) : '0';
        return;
      }
      if (key === '=') {
        this.calculate();
        return;
      }

      const operators = ['+', '-', '*', '/'];
      const lastChar = this.expression.charAt(this.expression.length - 1);

      // Guard against consecutive operators
      if (operators.includes(key) && operators.includes(lastChar)) {
        this.expression = this.expression.substring(0, this.expression.length - 1) + key;
        return;
      }

      if (this.expression === '0' && key !== '.') {
        this.expression = key;
      } else {
        this.expression += key;
      }
    } catch (err) {
      this.expression = '0';
    }
  }

  private calculate(): void {
    try {
      if (!this.expression || this.expression.trim().length === 0) {
        throw new Error('Empty expression');
      }

      // Prohibit division by zero
      if (this.expression.includes('/0')) {
        AlertDialog.show({ title: 'Math Error', message: 'Division by zero is not permitted.' });
        return;
      }

      // Strict custom expression parser without eval
      const result = this.parseSimpleMath(this.expression);
      if (Number.isNaN(result) || !Number.isFinite(result)) {
        throw new Error('Calculation error');
      }

      this.expression = (Math.round(result * 100) / 100).toString();
    } catch (e) {
      AlertDialog.show({ title: 'Error', message: 'Invalid math expression.' });
    }
  }

  private parseSimpleMath(expr: string): number {
    const tokens = expr.match(/(\d+(\.\d+)?|[\+\-\*\/])/g);
    if (!tokens || tokens.length === 0) {
      return 0;
    }

    // Step 1: multiplication and division
    const intermediate: (string | number)[] = [];
    let i = 0;
    while (i < tokens.length) {
      const token = tokens[i];
      if (token === '*' || token === '/') {
        const prev = parseFloat(intermediate.pop() as string);
        const next = parseFloat(tokens[++i]);
        if (token === '/') {
          if (next === 0) {
            throw new Error('Zero divisor');
          }
          intermediate.push(prev / next);
        } else {
          intermediate.push(prev * next);
        }
      } else {
        intermediate.push(token);
      }
      i++;
    }

    // Step 2: addition and subtraction
    let total = parseFloat(intermediate[0] as string);
    let j = 1;
    while (j < intermediate.length) {
      const op = intermediate[j];
      const nextVal = parseFloat(intermediate[j + 1] as string);
      if (op === '+') {
        total += nextVal;
      } else if (op === '-') {
        total -= nextVal;
      }
      j += 2;
    }

    return total;
  }

  build() {
    Column() {
      // Header & Expression Window
      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Text('Quick Calculator')
          .fontSize(14)
          .fontWeight(FontWeight.Bold)

        Button('✕')
          .fontSize(12)
          .height(24)
          .width(24)
          .backgroundColor('#CCCCCC')
          .onClick(() => this.onClose())
      }
      .width('100%')
      .margin({ bottom: 8 })

      Text(this.expression)
        .fontSize(22)
        .fontWeight(FontWeight.Bolder)
        .fontColor('#0A59F7')
        .width('100%')
        .textAlign(TextAlign.End)
        .padding(8)
        .backgroundColor('#F1F3F5')
        .borderRadius(6)
        .margin({ bottom: 10 })

      // Calculator Keypad using Flex with Wrap
      Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceBetween }) {
        ForEach(this.keys, (item: string) => {
          Button(item)
            .width('23%')
            .height(44)
            .margin({ bottom: 6 })
            .fontSize(16)
            .backgroundColor(
              item === '=' ? '#007DFF' : (['+', '-', '*', '/'].includes(item) ? '#FF9500' : '#E5E7EB')
            )
            .fontColor(
              item === '=' || ['+', '-', '*', '/'].includes(item) ? '#FFFFFF' : '#1F2937'
            )
            .onClick(() => this.handleKeyClick(item))
        })
      }
      .width('100%')

      // Use Result In Input Button
      Button('Use Result In Input')
        .width('100%')
        .height(36)
        .margin({ top: 6 })
        .backgroundColor('#007DFF')
        .onClick(() => {
          this.calculate();
          this.onConfirmResult(this.expression);
        })
    }
    .width(280)
    .padding(14)
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .shadow({ radius: 20, color: 'rgba(0,0,0,0.2)' })
  }
}