# 🌍 Planetary Commons Fund

**Decentralized funding platform for planetary restoration and environmental conservation projects**

[![Clarity](https://img.shields.io/badge/Clarity-Smart%20Contract-blue)](https://clarity-lang.org/)
[![Stacks](https://img.shields.io/badge/Stacks-Blockchain-orange)](https://stacks.co/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## 🌟 Overview

Planetary Commons Fund is a decentralized autonomous organization (DAO) that enables global communities to fund and govern environmental restoration projects. Built on the Stacks blockchain using Clarity smart contracts, it provides transparent, democratic funding for projects that benefit our planet's ecosystems.

## ✨ Key Features

### 🎯 Core Functionality
- **Environmental Project Funding** - Democratic funding allocation for restoration projects
- **Governance System** - Community-driven decision making through weighted voting
- **Treasury Management** - Transparent fund management and disbursement
- **Impact Tracking** - Comprehensive environmental impact assessment
- **Carbon Credit System** - Issue and manage verified carbon credits

### 🗳️ Democratic Governance
- **Proposal System** - Create and vote on funding proposals
- **Weighted Voting** - Voting power based on contributions and reputation
- **Milestone Verification** - Community-verified project milestones
- **Reputation Scoring** - Build credibility through consistent participation

### 🌱 Environmental Impact
- **Carbon Sequestration** - Track total carbon captured across projects
- **Biodiversity Monitoring** - Assess biodiversity impact scores
- **Community Benefits** - Measure local community improvements
- **Water & Soil Conservation** - Track restoration metrics

## 🚀 Quick Start

### Prerequisites
- [Clarinet](https://docs.hiro.so/stacks/clarinet) - Stacks smart contract development tool
- [Node.js](https://nodejs.org/) (v16 or later)
- [npm](https://www.npmjs.com/) or [yarn](https://yarnpkg.com/)

### Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/Planetary-Commons-Fund.git
cd Planetary-Commons-Fund

# Install dependencies
npm install

# Check contract syntax
clarinet check

# Run tests
npm test
```

## 🔧 Smart Contract Functions

### Contributor Management
```clarity
;; Register as a contributor to the fund
(register-contributor)

;; Contribute funds to the treasury
(contribute-to-treasury (amount uint))

;; Get contributor information
(get-contributor-data (contributor principal))

;; Calculate voting power
(calculate-voting-power (contributor principal))
```

### Project Management
```clarity
;; Submit an environmental project for funding
(submit-project 
  (title (string-ascii 100)) 
  (description (string-ascii 500)) 
  (funding-goal uint) 
  (carbon-impact uint) 
  (project-type (string-ascii 50)) 
  (location (string-ascii 100)) 
  (completion-deadline uint))

;; Get project details
(get-project-data (project-id uint))

;; Check project funding status
(get-project-funding-status (project-id uint))
```

### Governance & Voting
```clarity
;; Create a funding proposal
(create-funding-proposal 
  (project-id uint) 
  (requested-amount uint) 
  (proposal-type (string-ascii 30)))

;; Vote on a funding proposal
(vote-on-proposal (proposal-id uint) (vote-for bool))

;; Execute approved funding proposal
(execute-funding-proposal (proposal-id uint))

;; Get proposal information
(get-proposal-data (proposal-id uint))
```

### Milestone & Impact Tracking
```clarity
;; Create project milestone
(create-project-milestone 
  (project-id uint) 
  (milestone-title (string-ascii 100)) 
  (milestone-description (string-ascii 300)) 
  (funding-release uint))

;; Verify milestone completion
(verify-milestone-completion (milestone-id uint))

;; Submit environmental impact assessment
(submit-impact-assessment 
  (project-id uint) 
  (carbon-sequestered uint) 
  (biodiversity-score uint) 
  (community-benefit uint) 
  (water-conservation uint) 
  (soil-restoration uint))
```

### Carbon Credit System
```clarity
;; Issue carbon credits for completed projects
(issue-carbon-credits 
  (project-id uint) 
  (credits-generated uint) 
  (verification-standard (string-ascii 50)) 
  (price-per-credit uint))

;; Get carbon credit information
(get-carbon-credit-data (credit-id uint))
```

## 💰 Treasury & Economics

### Funding Model
- **Minimum Contribution**: 100 tokens
- **Voting Power**: Gained through contributions (1 voting power per 10 tokens contributed)
- **Reputation Rewards**: +5 reputation per treasury contribution
- **Governance Threshold**: 5,000 votes required for proposal passage
- **Minimum Proposal Stake**: 1,000 voting power to create proposals

### Project Funding
- **Minimum Project Goal**: 1,000 tokens
- **Democratic Approval**: Community vote required for funding
- **Milestone-Based Release**: Funds released based on verified milestones
- **Impact Verification**: Community assessment of environmental impact

## 📋 Project Categories

### 🌳 Supported Project Types
- **Forest Restoration** - Reforestation and forest conservation
- **Ocean Conservation** - Marine ecosystem protection and restoration
- **Renewable Energy** - Clean energy infrastructure projects
- **Carbon Sequestration** - Direct carbon capture initiatives
- **Biodiversity** - Wildlife habitat restoration and protection
- **Water Conservation** - Watershed protection and restoration
- **Soil Restoration** - Agricultural and land rehabilitation
- **Climate Adaptation** - Community resilience projects

## 🎭 User Roles & Permissions

### 🆕 New Contributors
- Register on platform
- Contribute to treasury
- View projects and proposals
- Basic platform access

### 🗳️ Active Contributors (1000+ Voting Power)
- Create funding proposals
- Vote on proposals
- Verify milestones
- Enhanced governance participation

### 🌟 Trusted Contributors (500+ Reputation)
- Submit impact assessments
- Advanced verification privileges
- Community leadership roles

### 👑 Platform Owner
- Update governance parameters
- Emergency fund withdrawal
- Platform administration

## 📊 Impact Metrics

Track comprehensive environmental impact:
- **Total Carbon Sequestered** - Global carbon capture across all projects
- **Projects Funded** - Number of successfully funded initiatives
- **Treasury Health** - Current fund balance and utilization
- **Community Growth** - Contributor participation and engagement
- **Biodiversity Score** - Aggregate ecosystem health improvements
- **Community Benefits** - Local socioeconomic impact measurements

## 🛠️ Development

### Running Tests
```bash
# Run all tests
npm test

# Run specific test file
npm test tests/planetary-commons.test.ts

# Test with coverage
npm run test:coverage
```

### Deployment
```bash
# Deploy to Testnet
clarinet deploy --testnet

# Deploy to Mainnet
clarinet deploy --mainnet
```

### Local Development
```bash
# Start Clarinet console
clarinet console

# Check contract
clarinet check

# Run integration tests
clarinet test
```

## 🏗️ Architecture

### Smart Contract Structure
- **Treasury Management** - Decentralized fund collection and disbursement
- **Governance System** - Proposal creation, voting, and execution
- **Project Lifecycle** - From submission to completion tracking
- **Impact Assessment** - Environmental and social impact measurement
- **Carbon Credits** - Verified credit issuance and management

### Key Components
- **Contributor Registry** - User management and reputation system
- **Project Database** - Environmental project metadata and status
- **Voting Mechanism** - Weighted democratic decision making
- **Milestone Tracking** - Progress verification and fund release
- **Impact Analytics** - Comprehensive environmental metrics

## 🌍 Environmental Impact

Planetary Commons Fund directly contributes to:
- **Climate Change Mitigation** - Funding carbon sequestration projects
- **Ecosystem Restoration** - Supporting biodiversity and habitat recovery
- **Community Resilience** - Building climate adaptation capacity
- **Sustainable Development** - Promoting regenerative practices
- **Global Cooperation** - Connecting environmental stewards worldwide

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details on:

- Code style and standards
- Pull request process
- Issue reporting
- Feature requests
- Testing requirements

### Development Setup
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Ensure all tests pass
6. Submit a pull request

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

- **Documentation**: [Stacks Documentation](https://docs.stacks.co/)
- **Clarity Language**: [Clarity Reference](https://clarity-lang.org/)
- **Community**: [Stacks Discord](https://discord.gg/stacks)
- **Issues**: [GitHub Issues](https://github.com/yourusername/Planetary-Commons-Fund/issues)

## 🙏 Acknowledgments

- Built on [Stacks Blockchain](https://stacks.co/)
- Powered by [Clarity Smart Contracts](https://clarity-lang.org/)
- Inspired by global environmental restoration movements
- Supporting UN Sustainable Development Goals

---

**Together, we can restore our planet through decentralized cooperation and transparent funding! 🌱🌍**
